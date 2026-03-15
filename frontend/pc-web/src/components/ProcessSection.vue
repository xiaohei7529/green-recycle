<template>
  <section class="process-section">
    <div class="container">
      <h2 class="section-title">回收流程</h2>
      <div class="process-steps">
        <div 
          class="process-step" 
          v-for="(step, index) in steps" 
          :key="index"
          :class="{ 'active': activeStep === index }"
          @mouseenter="activeStep = index"
        >
          <div class="step-number">
            {{ index + 1 }}
            <div class="step-icon">{{ step.icon }}</div>
          </div>
          <h3>{{ step.title }}</h3>
          <p>{{ step.description }}</p>
          <div class="step-detail" v-if="step.detail">
            {{ step.detail }}
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'ProcessSection',
  data() {
    return {
      activeStep: 0,
      steps: [
        { 
          icon: '📝',
          title: '在线下单', 
          description: '选择废品种类和数量，预约回收时间',
          detail: '支持废纸、塑料、金属、玻璃、纺织品等 5 大类'
        },
        { 
          icon: '🚚',
          title: '上门回收', 
          description: '回收员准时上门，称重确认',
          detail: '专业回收员，统一着装，电子秤称重'
        },
        { 
          icon: '💳',
          title: '即时结算', 
          description: '现场结算，支持多种支付方式',
          detail: '微信、支付宝、银行卡、积分抵扣'
        },
        { 
          icon: '🎁',
          title: '积分奖励', 
          description: '获得积分，兑换精美礼品',
          detail: '1 元=1 积分，100 积分起兑'
        }
      ]
    }
  }
}
</script>

<style scoped>
.process-section {
  padding: 6rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 24px;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 3rem;
}

.process-steps {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
}

.process-step {
  text-align: center;
  position: relative;
  padding: 2rem;
  border-radius: 16px;
  transition: all 0.3s ease;
}

.process-step:hover {
  background: #F9FAFB;
}

.process-step.active {
  background: linear-gradient(135deg, #ECFDF5 0%, #D1FAE5 100%);
  transform: translateY(-4px);
}

.step-number {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  font-size: 2rem;
  font-weight: 700;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem;
  box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
  position: relative;
  transition: all 0.3s ease;
}

.step-icon {
  position: absolute;
  font-size: 2rem;
  opacity: 0;
  transform: scale(0.5);
  transition: all 0.3s ease;
}

.process-step.active .step-number {
  transform: scale(1.1);
}

.process-step.active .step-icon {
  opacity: 1;
  transform: scale(1);
}

.process-step.active .step-number {
  font-size: 0;
}

.process-step h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.75rem;
}

.process-step p {
  color: #6B7280;
  line-height: 1.6;
}

.step-detail {
  margin-top: 1rem;
  padding: 0.75rem;
  background: white;
  border-radius: 8px;
  font-size: 0.9rem;
  color: #374151;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.process-step.active .step-detail {
  opacity: 1;
  transform: translateY(0);
}

@media (max-width: 768px) {
  .process-steps {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
}
</style>
