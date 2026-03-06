<template>
  <div class="profile">
    <h2>👤 个人中心</h2>
    
    <el-card>
      <el-descriptions title="个人信息" :column="2" border>
        <el-descriptions-item label="手机号">138****8000</el-descriptions-item>
        <el-descriptions-item label="昵称">用户昵称</el-descriptions-item>
        <el-descriptions-item label="积分">
          <el-tag type="warning">1250 分</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="累计订单">15 单</el-descriptions-item>
        <el-descriptions-item label="累计收益">¥358.50</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card style="margin-top: 20px">
      <template #header>
        <div class="card-header">
          <span>常用功能</span>
        </div>
      </template>
      <el-button type="primary">修改资料</el-button>
      <el-button>我的地址</el-button>
      <el-button>积分商城</el-button>
      <el-button>客服中心</el-button>
      <el-button type="danger">退出登录</el-button>
    </el-card>
  </div>
</template>

<script setup>
// 个人中心页面
</script>

<style scoped>
.profile {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
