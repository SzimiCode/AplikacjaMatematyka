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
    MatchOptionSerializer, ClassSerializer, CategorySerializer, DifficultyLevelSerializer,
    SaveLearningProgressSerializer, SaveQuizProgressSerializer
)

# endpointy do rejestracji, logowania i profilu uzytkownika
@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        
        # tworzenie JWT tokenów
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
    serializer = LoginSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    
    # próba znalezienia użytkownika
    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({
            'error': 'Nieprawidłowy email lub hasło'
        }, status=status.HTTP_401_UNAUTHORIZED)
    
    # sprawdzanie hasła
    if not user.check_password(password):
        return Response({
            'error': 'Nieprawidłowy email lub hasło'
        }, status=status.HTTP_401_UNAUTHORIZED)
    
    # stworzenie JWT tokenów
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
    serializer = UserSerializer(request.user)
    return Response(serializer.data)

@api_view(['GET'])
def get_question(request):
    questions = Question.objects.all()
    if not questions.exists():
        return Response({"error": "Brak pytań"}, status=404)
    question = random.choice(questions)
    serializer = QuestionSerializer(question)
    return Response(serializer.data)


@api_view(['GET'])
def ping(request):
    return Response({"status": "ok", "message": "Django API działa"})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_learning_progress(request):
    serializer = SaveLearningProgressSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    course_id = serializer.validated_data['course_id']
    fire_easy = serializer.validated_data.get('fire_easy', False)
    fire_medium = serializer.validated_data.get('fire_medium', False)
    fire_hard = serializer.validated_data.get('fire_hard', False)
    
    try:
        course = Course.objects.get(id=course_id)
    except Course.DoesNotExist:
        return Response({'error': 'Kurs nie istnieje'}, status=status.HTTP_404_NOT_FOUND)
    
    progress, created = UserCourseProgress.objects.get_or_create(
        user=request.user,
        course=course
    )
    
    if fire_easy and not progress.fire_easy:
        progress.fire_easy = True
    if fire_medium and not progress.fire_medium:
        progress.fire_medium = True
    if fire_hard and not progress.fire_hard:
        progress.fire_hard = True
    
    old_fires = progress.fires_earned
    progress.update_fires_earned()
    new_fires = progress.fires_earned
    fires_added = new_fires - old_fires
    
    if fires_added > 0:
        request.user.total_points += fires_added
        request.user.save()
    
    return Response({
        'message': 'Postęp zapisany!',
        'progress': UserCourseProgressSerializer(progress).data,
        'fires_added': fires_added,
        'total_points': request.user.total_points
    }, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_quiz_progress(request):
    serializer = SaveQuizProgressSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    course_id = serializer.validated_data['course_id']
    passed = serializer.validated_data['passed']
    
    try:
        course = Course.objects.get(id=course_id)
    except Course.DoesNotExist:
        return Response({'error': 'Kurs nie istnieje'}, status=status.HTTP_404_NOT_FOUND)
    
    progress, created = UserCourseProgress.objects.get_or_create(
        user=request.user,
        course=course
    )
    
    if passed and not progress.fire_quiz:
        progress.fire_quiz = True
        
        old_fires = progress.fires_earned
        progress.update_fires_earned()
        new_fires = progress.fires_earned
        fires_added = new_fires - old_fires
        
        if fires_added > 0:
            request.user.total_points += fires_added
            request.user.save()
        
        return Response({
            'message': 'Gratulacje! Zdobyłeś ogień za quiz!',
            'progress': UserCourseProgressSerializer(progress).data,
            'fires_added': fires_added,
            'total_points': request.user.total_points
        }, status=status.HTTP_200_OK)
    
    elif not passed:
        return Response({
            'message': 'Spróbuj ponownie!',
            'progress': UserCourseProgressSerializer(progress).data
        }, status=status.HTTP_200_OK)
    
    else:
        return Response({
            'message': 'Już masz ogień za ten quiz!',
            'progress': UserCourseProgressSerializer(progress).data
        }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_course_progress(request, course_id):
    try:
        course = Course.objects.get(id=course_id)
    except Course.DoesNotExist:
        return Response({'error': 'Kurs nie istnieje'}, status=status.HTTP_404_NOT_FOUND)
    
    try:
        progress = UserCourseProgress.objects.get(user=request.user, course=course)
        serializer = UserCourseProgressSerializer(progress)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except UserCourseProgress.DoesNotExist:
        return Response({
            'fires_earned': 0,
            'fire_easy': False,
            'fire_medium': False,
            'fire_hard': False,
            'fire_quiz': False,
        }, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def reset_user_progress(request):
    try:
        # Usuń wszystkie rekordy postępu użytkownika
        deleted_count = UserCourseProgress.objects.filter(user=request.user).delete()[0]
        
        # Zresetuj total_points użytkownika do 0
        request.user.total_points = 0
        request.user.save()
        
        return Response({
            'message': 'Postęp został zresetowany',
            'deleted_courses': deleted_count,
            'total_points': 0
        }, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({
            'error': f'Błąd podczas resetowania postępu: {str(e)}'
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# ========== VIEWSETS ==========

class ClassViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Class.objects.all().order_by('display_order')
    serializer_class = ClassSerializer
    permission_classes = [AllowAny]
    
    @action(detail=True, methods=['get'])
    def categories(self, request, pk=None):
        class_obj = self.get_object()
        categories = class_obj.categories.all().order_by('display_order')
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.all().order_by('display_order')
    serializer_class = CategorySerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Category.objects.all().order_by('display_order')
        class_id = self.request.query_params.get('class_id', None)
        if class_id is not None:
            queryset = queryset.filter(class_fk_id=class_id)
        return queryset
    
    @action(detail=True, methods=['get'])
    def courses(self, request, pk=None):
        category = self.get_object()
        courses = category.courses.all().order_by('display_order')
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)


class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all().order_by('display_order')
    serializer_class = CourseSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Course.objects.all().order_by('display_order')
        category_id = self.request.query_params.get('category_id', None)
        if category_id is not None:
            queryset = queryset.filter(category_id=category_id)
        return queryset
    
    @action(detail=True, methods=['get'])
    def questions(self, request, pk=None):
        course = self.get_object()
        questions = course.questions.all()
        
        question_type = self.request.query_params.get('type', None)
        if question_type:
            questions = questions.filter(question_type=question_type)
        
        difficulty_id = self.request.query_params.get('difficulty', None)
        if difficulty_id:
            questions = questions.filter(difficulty_level_id=difficulty_id)
        
        serializer = QuestionSerializer(questions, many=True)
        return Response(serializer.data)


class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [AllowAny]
    
    def get_queryset(self):
        queryset = Question.objects.all()
        
        course_id = self.request.query_params.get('course_id', None)
        if course_id:
            queryset = queryset.filter(course_id=course_id)

        question_type = self.request.query_params.get('type', None)
        if question_type:
            queryset = queryset.filter(question_type=question_type)
        
        difficulty_id = self.request.query_params.get('difficulty', None)
        if difficulty_id:
            queryset = queryset.filter(difficulty_level_id=difficulty_id)
        
        return queryset


class AnswerOptionViewSet(viewsets.ModelViewSet):
    queryset = AnswerOption.objects.all().order_by('display_order')
    serializer_class = AnswerOptionSerializer
    permission_classes = [AllowAny]


class MatchOptionViewSet(viewsets.ModelViewSet):
    queryset = MatchOption.objects.all().order_by('display_order')
    serializer_class = MatchOptionSerializer
    permission_classes = [AllowAny]


class DifficultyLevelViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = DifficultyLevel.objects.all().order_by('display_order')
    serializer_class = DifficultyLevelSerializer
    permission_classes = [AllowAny]


class UserCourseProgressViewSet(viewsets.ModelViewSet):
    queryset = UserCourseProgress.objects.all()
    serializer_class = UserCourseProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        # zwraca tylko postęp zalogowanego użytkownika
        return UserCourseProgress.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        # automatycznie przypisuje zalogowanego użytkownika
        serializer.save(user=self.request.user)
