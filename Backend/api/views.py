from django.shortcuts import render
from rest_framework import viewsets
from .models import Course, Question, AnswerOption, UserCourseProgress
from .serializers import CourseSerializer, QuestionSerializer, AnswerOptionSerializer, UserCourseProgressSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
import random

# endpoint do testowania - zwraca losowe pytanie z bazy
@api_view(['GET'])
def get_question(request):
    questions = Question.objects.all()  # bierze wszystkie pytania
    if not questions.exists():
        return Response({"error": "Brak pytań"}, status=404)
    
    question = random.choice(questions)  # losuje jedno pytanie
    serializer = QuestionSerializer(question)  # konwertuje na json
    return Response(serializer.data)

# prosty endpoint do sprawdzenia czy api dziala
@api_view(['GET'])
def ping(request):
    return Response({"status": "ok", "message": "Django API działa"})

# viewset dla kursow - obsluguje get, post, put, delete automatycznie
class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()  # wszystkie kursy
    serializer_class = CourseSerializer

# viewset dla pytan - zwraca pytania z opcjami odpowiedzi
class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer

# viewset dla opcji odpowiedzi (raczej nie uzywany osobno, bo laczy sie przez questions)
class AnswerOptionViewSet(viewsets.ModelViewSet):
    queryset = AnswerOption.objects.all()
    serializer_class = AnswerOptionSerializer

# viewset dla postepu uzytkownika w kursach
class UserCourseProgressViewSet(viewsets.ModelViewSet):
    queryset = UserCourseProgress.objects.all()
    serializer_class = UserCourseProgressSerializer