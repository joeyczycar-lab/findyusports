## 部署与迭代路线

### 环境
- Dev：本地 + Docker Compose（DB、Redis、MinIO 可选本地）
- Staging：单区云主机 + 托管DB/Redis + 对象存储+CDN
- Prod：多可用区，负载均衡，自动化备份，日志与监控

### 持续集成
- PR检查：ESLint/TypeCheck/Test；构建预览。
- 镜像：后端/前端分别构建Docker镜像，标记版本与环境。

### 里程碑
1. MVP：检索/地图/详情/点评/上传 + 审核基础
2. SEO与性能优化：SSR、meta、站点地图、LCP优化
3. 风控：限流、验证码、风控规则
4. 管理后台与运营组件
5. 搜索增强与推荐


