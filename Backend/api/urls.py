from django.urls import path, include
from rest_framework import routers
from .views import CourseViewSet, QuestionViewSet, AnswerOptionViewSet, UserCourseProgressViewSet

router = routers.DefaultRouter()
router.register(r'courses', CourseViewSet)
router.register(r'questions', QuestionViewSet)
router.register(r'options', AnswerOptionViewSet)
router.register(r'progress', UserCourseProgressViewSet)

urlpatterns = [
    path('', include(router.urls)),
]