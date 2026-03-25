export const STATUS_TYPE_MAP = {
  0: 'primary',
  1: 'warning',
  2: 'warning',
  3: 'success',
  4: 'danger'
}

export const STATUS_TEXT_MAP = {
  0: '待接单',
  1: '已接单',
  2: '回收中',
  3: '已完成',
  4: '已取消'
}

export function getStatusType(status) {
  return STATUS_TYPE_MAP[status] || 'default'
}

export function getStatusText(status) {
  return STATUS_TEXT_MAP[status] || '未知'
}
