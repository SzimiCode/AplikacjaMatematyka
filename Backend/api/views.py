from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from .models import Course, Question, AnswerOption, UserCourseProgress
from .serializers import CourseSerializer, QuestionSerializer, AnswerOptionSerializer, UserCourseProgressSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
import random

from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Question
from .serializers import QuestionSerializer
import random

@api_view(['GET'])
def get_test_question(request):
    questions = Question.objects.all()
    if not questions.exists():
        return Response({"error": "Brak pytań"}, status=404)

    question = random.choice(questions)
    serializer = QuestionSerializer(question)
    return Response(serializer.data)


@api_view(['GET'])
def ping(request):
    return Response({"status": "ok", "message": "Django API działa"})


class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer

class AnswerOptionViewSet(viewsets.ModelViewSet):
    queryset = AnswerOption.objects.all()
    serializer_class = AnswerOptionSerializer

class UserCourseProgressViewSet(viewsets.ModelViewSet):
    queryset = UserCourseProgress.objects.all()
    serializer_class = UserCourseProgressSerializer