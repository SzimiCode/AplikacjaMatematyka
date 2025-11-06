from django.test import TestCase
from django.urls import path
from .views import ping

# Create your tests here.

path('ping/', ping),