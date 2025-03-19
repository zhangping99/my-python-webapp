import unittest
from src.app import app

class TestApp(unittest.TestCase):
    def setUp(self):
        # 创建测试客户端
        self.client = app.test_client()

    def test_hello_world(self):
        # 测试根路由
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode('utf-8'), 'Hello, World!')

if __name__ == '__main__':
    unittest.main()
