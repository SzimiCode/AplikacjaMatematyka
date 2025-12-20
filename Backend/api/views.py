from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.decorators import api_view, permission_classes, action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
import random

from .models import (
    Course, MatchOption, Question, AnswerOption, UserCourseProgress, 
    User, Class, Category, DifficultyLevel
)
from .serializers import (
    CourseSerializer, QuestionSerializer, AnswerOptionSerializer,
    UserCourseProgressSerializer, RegisterSerializer, UserSerializer, LoginSerializer,
    MatchOptionSerializer, ClassSerializer, CategorySerializer, DifficultyLevelSerializer
)

# ========== AUTHENTICATION ENDPOINTS ==========

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    """Endpoint do rejestracji nowego użytkownika"""
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        
        # Tworzenie JWT tokenów
        refresh = RefreshToken.for_user(user)
        
        return Response({
            'user': UserSerializer(user).data,
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'message': 'Rejestracja zakończona sukcesem!'
        }, status=status.HTTP_201_CREATED)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    """Endpoint do logowania użytkownika"""
    serializer = LoginSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    
    # Próba znalezienia użytkownika
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'error': 'Nieprawidłowy email lub hasło'
        }, status=status.HTTP_401_UNAUTHORIZED)
    
    # Sprawdzanie hasła
    if not user.check_password(password):
        return Response({
            'error': 'Nieprawidłowy email lub hasło'
        }, status=status.HTTP_401_UNAUTHORIZED)
    
    # Tworzenie JWT tokenów
    refresh = RefreshToken.for_user(user)
    
    return Response({
        'user': UserSerializer(user).data,
        'refresh': str(refresh),
        'access': str(refresh.access_token),
        'message': 'Logowanie zakończone sukcesem!'
    }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_profile(request):
    """Endpoint do pobierania profilu zalogowanego użytkownika"""
    serializer = UserSerializer(request.user)
    return Response(serializer.data)


# ========== EXISTING ENDPOINTS ==========

@api_view(['GET'])
def get_question(request):
    """Endpoint testowy - zwraca losowe pytanie"""
    questions = Question.objects.all()
    if not questions.exists():
        return Response({"error": "Brak pytań"}, status=404)
    question = random.choice(questions)
    serializer = QuestionSerializer(question)
    return Response(serializer.data)


@api_view(['GET'])
def ping(request):
    """Endpoint do sprawdzenia czy API działa"""
    return Response({"status": "ok", "message": "Django API działa"})


# ========== VIEWSETS ==========

class ClassViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet dla klas (1-4)"""
    queryset = Class.objects.all().order_by('display_order')
    serializer_class = ClassSerializer
    permission_classes = [AllowAny]
    
    @action(detail=True, methods=['get'])
    def categories(self, request, pk=None):
        """Zwraca wszystkie kategorie dla danej klasy"""
        class_obj = self.get_object()
        categories = class_obj.categories.all().order_by('display_order')
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet dla kategorii"""
    queryset = Category.objects.all().order_by('display_order')
    serializer_class = CategorySerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Category.objects.all().order_by('display_order')
        # Filtrowanie po klasie jeśli podano parametr
        class_id = self.request.query_params.get('class_id', None)
        if class_id is not None:
            queryset = queryset.filter(class_fk_id=class_id)
        return queryset
    
    @action(detail=True, methods=['get'])
    def courses(self, request, pk=None):
        """Zwraca wszystkie kursy dla danej kategorii"""
        category = self.get_object()
        courses = category.courses.all().order_by('display_order')
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)


class CourseViewSet(viewsets.ModelViewSet):
    """ViewSet dla kursów"""
    queryset = Course.objects.all().order_by('display_order')
    serializer_class = CourseSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Course.objects.all().order_by('display_order')
        # Filtrowanie po kategorii jeśli podano parametr
        category_id = self.request.query_params.get('category_id', None)
        if category_id is not None:
            queryset = queryset.filter(category_id=category_id)
        return queryset
    
    @action(detail=True, methods=['get'])
    def questions(self, request, pk=None):
        """Zwraca wszystkie pytania dla danego kursu"""
        course = self.get_object()
        questions = course.questions.all()
        
        # Filtrowanie po typie pytania jeśli podano parametr
        question_type = self.request.query_params.get('type', None)
        if question_type:
            questions = questions.filter(question_type=question_type)
        
        # Filtrowanie po poziomie trudności jeśli podano parametr
        difficulty_id = self.request.query_params.get('difficulty', None)
        if difficulty_id:
            questions = questions.filter(difficulty_level_id=difficulty_id)
        
        serializer = QuestionSerializer(questions, many=True)
        return Response(serializer.data)


class QuestionViewSet(viewsets.ModelViewSet):
    """ViewSet dla pytań"""
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Question.objects.all()
        
        # Filtrowanie po kursie
        course_id = self.request.query_params.get('course_id', None)
        if course_id:
            queryset = queryset.filter(course_id=course_id)
        
        # Filtrowanie po typie pytania
        question_type = self.request.query_params.get('type', None)
        if question_type:
            queryset = queryset.filter(question_type=question_type)
        
        # Filtrowanie po poziomie trudności
        difficulty_id = self.request.query_params.get('difficulty', None)
        if difficulty_id:
            queryset = queryset.filter(difficulty_level_id=difficulty_id)
        
        return queryset


class AnswerOptionViewSet(viewsets.ModelViewSet):
    """ViewSet dla opcji odpowiedzi"""
    queryset = AnswerOption.objects.all().order_by('display_order')
    serializer_class = AnswerOptionSerializer
    permission_classes = [AllowAny]


class MatchOptionViewSet(viewsets.ModelViewSet):
    """ViewSet dla opcji dopasowania"""
    queryset = MatchOption.objects.all().order_by('display_order')
    serializer_class = MatchOptionSerializer
    permission_classes = [AllowAny]


class DifficultyLevelViewSet(viewsets.ReadOnlyModelViewSet):
    """ViewSet dla poziomów trudności"""
    queryset = DifficultyLevel.objects.all().order_by('display_order')
    serializer_class = DifficultyLevelSerializer
    permission_classes = [AllowAny]


class UserCourseProgressViewSet(viewsets.ModelViewSet):
    """ViewSet dla postępu użytkownika"""
    queryset = UserCourseProgress.objects.all()
    serializer_class = UserCourseProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        # Zwraca tylko postęp zalogowanego użytkownika
        return UserCourseProgress.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # Automatycznie przypisuje zalogowanego użytkownika
        serializer.save(user=self.request.user)