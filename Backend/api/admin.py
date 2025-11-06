from django.contrib import admin
from .models import Class, Category, Course, DifficultyLevel, Question, AnswerOption

# rejestracja modeli zeby byly widoczne w panelu /admin
# dzieki temu mozna dodawac/edytowac dane przez przegladarke
admin.site.register(Class)
admin.site.register(Category)
admin.site.register(Course)
admin.site.register(DifficultyLevel)
admin.site.register(Question)
admin.site.register(AnswerOption)