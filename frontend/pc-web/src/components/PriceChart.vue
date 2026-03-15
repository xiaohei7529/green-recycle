<template>
  <div class="price-chart">
    <div class="chart-header">
      <h3>📊 价格趋势</h3>
      <div class="time-range">
        <button 
          :class="{ active: timeRange === '7d' }" 
          @click="setTimeRange('7d')"
        >
          7 天
        </button>
        <button 
          :class="{ active: timeRange === '30d' }" 
          @click="setTimeRange('30d')"
        >
          30 天
        </button>
        <button 
          :class="{ active: timeRange === '90d' }" 
          @click="setTimeRange('90d')"
        >
          90 天
        </button>
      </div>
    </div>
    
    <div ref="chartRef" class="chart-container"></div>
    
    <div class="chart-footer">
      <div class="category-legend">
        <span 
          v-for="cat in categories" 
          :key="cat.name"
          class="legend-item"
        >
          <span class="legend-dot" :style="{ background: cat.color }"></span>
          {{ cat.name }}
        </span>
      </div>
    </div>
  </div>
</template>

<script>
import { markRaw } from 'vue'

export default {
  name: 'PriceChart',
  data() {
    return {
      timeRange: '7d',
      chart: null,
      categories: [
        { name: '废纸', color: '#10B981' },
        { name: '塑料', color: '#3B82F6' },
        { name: '金属', color: '#F59E0B' },
        { name: '玻璃', color: '#6B7280' },
        { name: '纺织品', color: '#EC4899' }
      ],
      chartData: {
        '7d': [],
        '30d': [],
        '90d': []
      }
    }
  },
  mounted() {
    this.initChart()
    this.loadData()
    window.addEventListener('resize', this.handleResize)
  },
  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
    if (this.chart) {
      this.chart.dispose()
    }
  },
  methods: {
    async initChart() {
      // 动态导入 ECharts
      const echarts = await import('echarts')
      this.chart = markRaw(echarts.init(this.$refs.chartRef))
      
      const option = {
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#E5E7EB',
          borderWidth: 1,
          textStyle: {
            color: '#374151'
          },
          formatter: (params) => {
            let html = `<div style="font-weight: 600; margin-bottom: 8px;">${params[0].name}</div>`
            params.forEach(param => {
              html += `<div style="display: flex; align-items: center; gap: 6px;">
                <span style="width: 10px; height: 10px; border-radius: 50%; background: ${param.color};"></span>
                ${param.seriesName}: ¥${param.value}/kg
              </div>`
            })
            return html
          }
        },
        legend: {
          show: false
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '10%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [],
          axisLine: {
            lineStyle: {
              color: '#E5E7EB'
            }
          },
          axisLabel: {
            color: '#6B7280',
            margin: 15
          }
        },
        yAxis: {
          type: 'value',
          name: '价格 (元/kg)',
          min: 0,
          axisLine: {
            show: false
          },
          axisTick: {
            show: false
          },
          splitLine: {
            lineStyle: {
              color: '#F3F4F6',
              type: 'dashed'
            }
          },
          axisLabel: {
            color: '#6B7280',
            formatter: (value) => `¥${value}`
          }
        },
        series: this.categories.map(cat => ({
          name: cat.name,
          type: 'line',
          smooth: true,
          symbol: 'circle',
          symbolSize: 6,
          data: [],
          lineStyle: {
            width: 2,
            color: cat.color
          },
          itemStyle: {
            color: cat.color,
            borderWidth: 2,
            borderColor: '#fff'
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              {
                offset: 0,
                color: cat.color + '40' // 25% opacity
              },
              {
                offset: 1,
                color: cat.color + '05' // 3% opacity
              }
            ])
          }
        }))
      }
      
      this.chart.setOption(option)
    },
    
    async loadData() {
      // TODO: 从 API 加载实际数据
      // 模拟数据
      const days = this.timeRange === '7d' ? 7 : this.timeRange === '30d' ? 30 : 90
      const dates = []
      const now = new Date()
      
      for (let i = days - 1; i >= 0; i--) {
        const date = new Date(now)
        date.setDate(date.getDate() - i)
        dates.push(date.toLocaleDateString('zh-CN', { month: 'short', day: 'numeric' }))
      }
      
      // 生成模拟数据
      const basePrices = [1.5, 2.0, 3.5, 0.8, 2.5]
      const seriesData = this.categories.map((cat, idx) => {
        return basePrices[idx] + Array(days).fill(0).map(() => (Math.random() - 0.5) * 0.3)
      })
      
      this.chart.setOption({
        xAxis: { data: dates },
        series: this.categories.map((cat, idx) => ({
          name: cat.name,
          data: seriesData[idx].map((price, i) => +(price + (i * 0.01)).toFixed(2))
        }))
      })
    },
    
    setTimeRange(range) {
      this.timeRange = range
      this.loadData()
    },
    
    handleResize() {
      if (this.chart) {
        this.chart.resize()
      }
    }
  }
}
</script>

<style scoped>
.price-chart {
  background: white;
  border-radius: 16px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.chart-header h3 {
  font-size: 1.25rem;
  font-weight: 700;
  color: #111827;
}

.time-range {
  display: flex;
  gap: 0.5rem;
}

.time-range button {
  padding: 6px 12px;
  font-size: 0.875rem;
  font-weight: 500;
  color: #6B7280;
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.time-range button:hover {
  background: #F3F4F6;
  border-color: #D1D5DB;
}

.time-range button.active {
  background: #10B981;
  color: white;
  border-color: #10B981;
}

.chart-container {
  width: 100%;
  height: 300px;
}

.chart-footer {
  margin-top: 1.5rem;
  padding-top: 1rem;
  border-top: 1px solid #E5E7EB;
}

.category-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  justify-content: center;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.875rem;
  color: #6B7280;
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
}
</style>
