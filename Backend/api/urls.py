from django.urls import path, include
from rest_framework import routers
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    CourseViewSet, QuestionViewSet, AnswerOptionViewSet, 
    UserCourseProgressViewSet, get_question, ping,
    register, login, get_user_profile
)

router = routers.DefaultRouter()
router.register(r'courses', CourseViewSet)
router.register(r'questions', QuestionViewSet)
router.register(r'options', AnswerOptionViewSet)
router.register(r'progress', UserCourseProgressViewSet)

urlpatterns = [
    # Authentication endpoints
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('user/', get_user_profile, name='user_profile'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Existing endpoints
    path('get-question/', get_question),
    path('ping/', ping),
    
    # Router endpoints
    path('', include(router.urls)),
]