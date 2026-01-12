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
    # Authentication endpoints
    path('register/', register, name='register'),
    path('login/', login, name='login'),
    path('user/', get_user_profile, name='user_profile'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    # Test endpoints
    path('get-question/', get_question),
    path('ping/', ping),
    
    # Router endpoints (automatycznie generowane)
    # /api/classes/ - lista klas
    # /api/classes/{id}/ - szczegóły klasy
    # /api/classes/{id}/categories/ - kategorie dla klasy
    # /api/categories/ - lista kategorii (z ?class_id=X do filtrowania)
    # /api/categories/{id}/ - szczegóły kategorii
    # /api/categories/{id}/courses/ - kursy dla kategorii
    # /api/courses/ - lista kursów (z ?category_id=X do filtrowania)
    # /api/courses/{id}/ - szczegóły kursu
    # /api/courses/{id}/questions/ - pytania dla kursu (z ?type=X i ?difficulty=X)
    # /api/questions/ - lista pytań (z ?course_id=X, ?type=X, ?difficulty=X)
    # /api/match-options/ - opcje dopasowania
    # /api/difficulty-levels/ - poziomy trudności
    # /api/progress/ - postęp użytkownika (wymaga autentykacji)

    path('progress-reset/', reset_user_progress, name='reset_user_progress'),
    path('learning/save/', save_learning_progress, name='save_learning_progress'),
    path('quiz/save/', save_quiz_progress, name='save_quiz_progress'),
    path('course-progress/<int:course_id>/', get_course_progress, name='get_course_progress'),

    path('', include(router.urls)),    
]