-- 添加收费方式字段到 venue 表（散客 / 包场）
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_walk_in BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_full_court BOOLEAN;

{
  "cells": [],
  "metadata": {
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 2
}