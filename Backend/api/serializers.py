from rest_framework import serializers
from .models import Course, Question, AnswerOption, UserCourseProgress

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'


class QuestionSerializer(serializers.ModelSerializer):
    options = serializers.StringRelatedField(many=True)

    class Meta:
        model = Question
        fields = '__all__'


class AnswerOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnswerOption
        fields = '__all__'


class UserCourseProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCourseProgress
        fields = '__all__'