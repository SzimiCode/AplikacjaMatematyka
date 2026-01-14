from django.urls import path, include
from rest_framework import routers
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    CourseViewSet, QuestionViewSet, AnswerOptionViewSet, 
    UserCourseProgressViewSet, get_question, ping,
    register, login, get_user_profile,
    ClassViewSet, CategoryViewSet, MatchOptionViewSet, DifficultyLevelViewSet,
    save_learning_progress, save_quiz_progress, get_course_progress,
    reset_user_progress
)

router = routers.DefaultRouter()
router.register(r'classes', ClassViewSet)
router.register(r'categories', CategoryViewSet)
router.register(r'courses', CourseViewSet)
router.register(r'questions', QuestionViewSet)
router.register(r'options', AnswerOptionViewSet)
router.register(r'match-options', MatchOptionViewSet)
router.register(r'difficulty-levels', DifficultyLevelViewSet)
router.register(r'progress', UserCourseProgressViewSet)

urlpatterns = [
    # endpointy do rejestracji, logowania, profilu uzytkownika
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('user/', get_user_profile, name='user_profile'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    path('get-question/', get_question),
    path('ping/', ping),

    # endpointy do zarządzania postępem użytkownika
    path('progress-reset/', reset_user_progress, name='reset_user_progress'),
    path('learning/save/', save_learning_progress, name='save_learning_progress'),
    path('quiz/save/', save_quiz_progress, name='save_quiz_progress'),
    path('course-progress/<int:course_id>/', get_course_progress, name='get_course_progress'),

    path('', include(router.urls)),    
]