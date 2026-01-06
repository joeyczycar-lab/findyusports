# 快速同步 Railway 数据到本地

## 🚀 最简单的方法

### 使用批处理脚本（推荐）

1. **获取 Railway DATABASE_URL**
   - 登录 Railway：https://railway.app
   - 进入数据库服务
   - 点击 "Connect" 或 "Variables"
   - 复制 `DATABASE_URL` 或 `POSTGRES_URL`

2. **运行同步脚本**
   ```cmd
   cd F:\Findyu\Server\api
   sync-railway.bat
   ```

3. **按提示输入 DATABASE_URL**

4. **等待同步完成**

---

## 📋 同步的表

脚本会同步以下表的数据：
- `venue` - 场地数据
- `venue_image` - 场地图片
- `review` - 评论
- `app_user` - 用户

---

## ⚠️ 注意事项

### 如果本地已有数据

如果本地数据库已有数据，导入时可能会遇到 ID 冲突。

**解决方案：**

1. **清空本地数据后同步**（会删除本地所有数据）
   ```cmd
   docker exec venues_pg psql -U postgres -d venues -c "TRUNCATE TABLE review, venue_image, venue, app_user CASCADE;"
   ```
   然后运行同步脚本。

2. **只同步新数据**（保留本地数据）
   - 需要手动处理 ID 冲突
   - 或使用更复杂的合并脚本

---

## 🔄 定期同步

每次需要最新数据时，运行：
```cmd
cd F:\Findyu\Server\api
sync-railway.bat
```

---

## ✅ 验证同步结果

同步完成后，检查数据：

```cmd
# 查看场地数量
docker exec venues_pg psql -U postgres -d venues -c "SELECT COUNT(*) FROM venue;"

# 查看前几条场地
docker exec venues_pg psql -U postgres -d venues -c "SELECT id, name, city_code FROM venue LIMIT 5;"
```

---

## 🐛 常见问题

### Q1: 导出失败

**原因**：DATABASE_URL 不正确或网络问题

**解决**：
1. 检查 DATABASE_URL 是否正确
2. 确认 Railway 数据库服务正在运行
3. 检查网络连接

### Q2: 导入失败 "relation does not exist"

**原因**：本地数据库表不存在

**解决**：
```cmd
cd F:\Findyu\Server\api
npm run migration:run
```

### Q3: 导入失败 "duplicate key"

**原因**：本地已有相同 ID 的数据

**解决**：先清空本地数据（见上面的注意事项）

---

**完成同步后，你就可以在本地看到 Railway 的场地数据了！** 🎉



