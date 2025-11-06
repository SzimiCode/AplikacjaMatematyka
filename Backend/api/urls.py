from django.urls import path, include
from rest_framework import routers
from .views import CourseViewSet, QuestionViewSet, AnswerOptionViewSet, UserCourseProgressViewSet, get_question

# router automatycznie tworzy endpointy dla viewsetow
router = routers.DefaultRouter()
router.register(r'courses', CourseViewSet)  # /api/courses/
router.register(r'questions', QuestionViewSet)  # /api/questions/
router.register(r'options', AnswerOptionViewSet)  # /api/options/
router.register(r'progress', UserCourseProgressViewSet)  # /api/progress/

urlpatterns = [
    path('', include(router.urls)),  # dodaje wszystkie endpointy z routera
    path('get-question/', get_question),  # dodatkowy endpoint na /api/get-question/
]