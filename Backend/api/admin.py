from django.contrib import admin

# Register your models here.

from django.contrib import admin
from .models import Class, Category, Course, DifficultyLevel, Question, AnswerOption

admin.site.register(Class)
admin.site.register(Category)
admin.site.register(Course)
admin.site.register(DifficultyLevel)
admin.site.register(Question)
admin.site.register(AnswerOption)