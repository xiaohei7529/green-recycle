<template>
  <div class="users">
    <h2>👥 用户管理</h2>
    
    <el-card>
      <el-table :data="users" style="width: 100%">
        <el-table-column prop="user_id" label="用户 ID" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="nickname" label="昵称" />
        <el-table-column prop="points" label="积分" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="注册时间" />
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small">编辑</el-button>
            <el-button size="small" :type="row.status === 1 ? 'danger' : 'success'">
              {{ row.status === 1 ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const users = ref([
  { user_id: 1, phone: '13800138000', nickname: '测试用户', points: 1250, status: 1, created_at: '2026-03-01' },
  { user_id: 2, phone: '13900139000', nickname: '张三', points: 580, status: 1, created_at: '2026-03-02' }
])
</script>

<style scoped>
.users {
  padding: 20px;
}

.users h2 {
  margin-bottom: 20px;
}
</style>
