<template>
  <div class="captcha-input">
    <div class="input-group">
      <input 
        v-model="captchaCode"
        type="text"
        maxlength="6"
        placeholder="输入验证码"
        class="captcha-input-field"
        @input="validate"
      />
      <div 
        class="captcha-image"
        @click="refreshCaptcha"
        title="点击刷新"
      >
        <canvas ref="canvasRef" width="120" height="40"></canvas>
        <div class="refresh-overlay" v-if="loading">
          <span class="loading-spinner">⟳</span>
        </div>
      </div>
    </div>
    <div class="error-message" v-if="error">
      {{ error }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'CaptchaInput',
  props: {
    modelValue: {
      type: String,
      default: ''
    }
  },
  emits: ['update:modelValue', 'verified'],
  data() {
    return {
      captchaCode: this.modelValue,
      generatedCaptcha: '',
      error: '',
      loading: false
    }
  },
  watch: {
    captchaCode(val) {
      this.$emit('update:modelValue', val)
    },
    modelValue(val) {
      this.captchaCode = val
    }
  },
  mounted() {
    this.generateCaptcha()
  },
  methods: {
    generateCaptcha() {
      this.loading = true
      const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ' // 排除易混淆字符
      let captcha = ''
      for (let i = 0; i < 6; i++) {
        captcha += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      this.generatedCaptcha = captcha
      this.drawCaptcha(captcha)
      setTimeout(() => {
        this.loading = false
      }, 300)
    },
    
    drawCaptcha(code) {
      const canvas = this.$refs.canvasRef
      const ctx = canvas.getContext('2d')
      
      // 清空画布
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      
      // 随机背景色
      const bgColors = ['#F0FDF4', '#DCFCE7', '#BBF7D0', '#ECFDF5']
      ctx.fillStyle = bgColors[Math.floor(Math.random() * bgColors.length)]
      ctx.fillRect(0, 0, canvas.width, canvas.height)
      
      // 添加干扰线
      for (let i = 0; i < 5; i++) {
        ctx.beginPath()
        ctx.moveTo(Math.random() * canvas.width, Math.random() * canvas.height)
        ctx.lineTo(Math.random() * canvas.width, Math.random() * canvas.height)
        ctx.strokeStyle = `rgba(16, 185, 129, ${0.1 + Math.random() * 0.2})`
        ctx.lineWidth = 1 + Math.random() * 2
        ctx.stroke()
      }
      
      // 添加干扰点
      for (let i = 0; i < 30; i++) {
        ctx.beginPath()
        ctx.arc(
          Math.random() * canvas.width,
          Math.random() * canvas.height,
          1 + Math.random() * 2,
          0,
          Math.PI * 2
        )
        ctx.fillStyle = `rgba(16, 185, 129, ${0.2 + Math.random() * 0.3})`
        ctx.fill()
      }
      
      // 绘制验证码文字
      const fontSize = 24
      const charWidth = canvas.width / code.length
      for (let i = 0; i < code.length; i++) {
        const char = code[i]
        const x = i * charWidth + 10
        const y = canvas.height / 2 + fontSize / 2
        
        ctx.save()
        
        // 随机旋转
        const angle = (Math.random() - 0.5) * 0.4
        ctx.translate(x, y)
        ctx.rotate(angle)
        
        // 随机颜色
        const colors = ['#059669', '#047857', '#065F46', '#10B981']
        ctx.fillStyle = colors[Math.floor(Math.random() * colors.length)]
        
        // 随机字体大小
        ctx.font = `bold ${fontSize - 2 + Math.random() * 4}px Arial`
        
        ctx.textAlign = 'center'
        ctx.textBaseline = 'middle'
        ctx.fillText(char, 0, 0)
        
        ctx.restore()
      }
    },
    
    refreshCaptcha() {
      if (this.loading) return
      this.generateCaptcha()
      this.captchaCode = ''
      this.error = ''
    },
    
    validate() {
      if (this.captchaCode.length === 6) {
        if (this.captchaCode.toUpperCase() === this.generatedCaptcha) {
          this.error = ''
          this.$emit('verified', true)
        } else {
          this.error = '验证码错误，请重试'
          this.$emit('verified', false)
          // 3 秒后自动刷新
          setTimeout(() => {
            if (this.error) {
              this.refreshCaptcha()
            }
          }, 3000)
        }
      } else {
        this.error = ''
      }
    }
  }
}
</script>

<style scoped>
.captcha-input {
  width: 100%;
}

.input-group {
  display: flex;
  gap: 12px;
  align-items: center;
}

.captcha-input-field {
  flex: 1;
  padding: 14px 16px;
  border: 2px solid #E5E7EB;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.2s;
  outline: none;
}

.captcha-input-field:focus {
  border-color: #10B981;
  box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
}

.captcha-image {
  width: 120px;
  height: 44px;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  position: relative;
  border: 2px solid #E5E7EB;
  transition: all 0.2s;
}

.captcha-image:hover {
  border-color: #10B981;
  transform: scale(1.05);
}

.refresh-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
}

.loading-spinner {
  font-size: 1.5rem;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-message {
  margin-top: 8px;
  color: #EF4444;
  font-size: 0.875rem;
  display: flex;
  align-items: center;
  gap: 6px;
}

.error-message::before {
  content: '⚠️';
}
</style>
