## API 接口规范（草案）

基于 REST，建议遵循 OpenAPI 3 规范。鉴权采用 Bearer JWT；上传采用服务端签名直传。

### 认证
- POST /api/auth/sms/send { phone }
- POST /api/auth/sms/login { phone, code } → { token }

### 场地
- GET /api/venues?city=310000&sport=basketball&indoor=true&minPrice=0&maxPrice=100&sort=distance&lat=31.23&lng=121.47&page=1&pageSize=20
- GET /api/venues/{id}
- POST /api/venues （需登录，进入审核）
- PATCH /api/venues/{id} （需权限，认领或管理员）

### 点评
- GET /api/venues/{id}/reviews?page=1&pageSize=20
- POST /api/venues/{id}/reviews （需登录）

### 收藏
- POST /api/venues/{id}/favorite （需登录）
- DELETE /api/venues/{id}/favorite （需登录）
- GET /api/me/favorites

### 上传
- GET /api/upload/presign?mime=image/jpeg&ext=jpg （返回直传凭证与上传URL）
- POST /api/upload/callback （对象存储回调校验）

### 审核（后台）
- GET /api/admin/venues?status=pending
- POST /api/admin/venues/{id}/approve
- POST /api/admin/venues/{id}/reject { reason }

### 错误响应
```json
{ "error": { "code": "BadRequest", "message": "xx" } }
```


