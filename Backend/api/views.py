from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
import random

from .models import Course, MatchOption, Question, AnswerOption, UserCourseProgress, User
from .serializers import (
    CourseSerializer, QuestionSerializer, AnswerOptionSerializer,
    UserCourseProgressSerializer, RegisterSerializer, UserSerializer, LoginSerializer,
    MatchOptionSerializer
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


# ViewSets
class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer


class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer


class AnswerOptionViewSet(viewsets.ModelViewSet):
    queryset = AnswerOption.objects.all()
    serializer_class = AnswerOptionSerializer

class MatchOptionViewSet(viewsets.ModelViewSet):
    queryset = MatchOption.objects.all()
    serializer_class = MatchOptionSerializer


class UserCourseProgressViewSet(viewsets.ModelViewSet):
    queryset = UserCourseProgress.objects.all()
    serializer_class = UserCourseProgressSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        # Zwraca tylko postęp zalogowanego użytkownika
        return UserCourseProgress.objects.filter(user=self.request.user)