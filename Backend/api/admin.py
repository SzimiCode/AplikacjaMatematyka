from django.contrib import admin
from .models import (
    User, Class, Category, Course, DifficultyLevel,
    Question, AnswerOption, UserCourseProgress,
    UserAnswer, MatchOption)

# rejestracja modeli zeby byly widoczne w panelu /admin
# dzieki temu mozna dodawac/edytowac dane przez przegladarke
admin.site.register(Class)
admin.site.register(Category)
admin.site.register(Course)
admin.site.register(DifficultyLevel)
admin.site.register(Question)
admin.site.register(AnswerOption)
admin.site.register(User)
admin.site.register(UserCourseProgress)
admin.site.register(UserAnswer)
admin.site.register(MatchOption)