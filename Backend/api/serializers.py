from rest_framework import serializers
from .models import Course, Question, AnswerOption, UserCourseProgress

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'

class AnswerOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnswerOption
        fields = ['id', 'option_text', 'is_correct']  # tylko potrzebne pola

class QuestionSerializer(serializers.ModelSerializer):
    options = AnswerOptionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Question
        fields = ['id', 'question_text', 'question_type', 'points', 'options']  # <- bez aliasu

class UserCourseProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCourseProgress
        fields = '__all__'