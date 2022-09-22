import unittest
from datetime import datetime
from unittest.mock import patch

from src.main import akiri
from src.main import meow


class TestSrc(unittest.TestCase):
    def test_meow(self):
        self.assertEqual("meow!", meow())

    def test_akiri(self):
        with patch("src.main.datetime") as mock_datetime:
            mock_datetime_iso = "2021-01-29 10:25:58.095339"
            mock_datetime.now.return_value = datetime.fromisoformat(mock_datetime_iso)

            expected = f"[{mock_datetime.now.return_value.isoformat()}] test_value: 2.35"
            result = akiri("test_value", 2.345689)

            self.assertEqual(expected, result)