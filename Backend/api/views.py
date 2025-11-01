from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from .models import Course, Question, AnswerOption, UserCourseProgress
from .serializers import CourseSerializer, QuestionSerializer, AnswerOptionSerializer, UserCourseProgressSerializer

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