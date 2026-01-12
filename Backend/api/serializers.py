from rest_framework import serializers
from .models import (
    Course, Question, AnswerOption, UserCourseProgress, User, 
    MatchOption, Class, Category, DifficultyLevel
)
from django.contrib.auth.password_validation import validate_password

# ========== AUTH SERIALIZERS ==========

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True, label="Potwierdź hasło")
    
    class Meta:
        model = User
        fields = ['email', 'nick', 'full_name', 'phone_number', 'password', 'password2']
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Hasła się nie zgadzają"})
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(
            email=validated_data['email'],
            nick=validated_data['nick'],
            password=validated_data['password'],
            full_name=validated_data.get('full_name', ''),
            phone_number=validated_data.get('phone_number', ''),
        )
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'nick', 'full_name', 'phone_number', 'dragon_name', 'total_points', 'created_at']
        read_only_fields = ['id', 'created_at']

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

# ========== CORE SERIALIZERS ==========

# Serializer dla klasy (1-4)
class ClassSerializer(serializers.ModelSerializer):
    class Meta:
        model = Class
        fields = ['id', 'class_name', 'description', 'display_order']

# Serializer dla kategorii (z informacją o klasie)
class CategorySerializer(serializers.ModelSerializer):
    class_name = serializers.CharField(source='class_fk.class_name', read_only=True)
    
    class Meta:
        model = Category
        fields = ['id', 'class_fk', 'class_name', 'category_name', 'description', 'icon_url', 'display_order']

# Serializer dla poziomu trudności
class DifficultyLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = DifficultyLevel
        fields = ['id', 'level_name', 'level_code', 'display_order']

# Serializer dla kursu (z informacją o kategorii)
class CourseSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.category_name', read_only=True)
    full_video_url = serializers.SerializerMethodField()
    
    class Meta:
        model = Course
        fields = [
            'id', 'category', 'category_name', 'course_name', 'description', 
            'video_url', 'full_video_url', 'points_per_question', 
            'required_correct_answers', 'display_order', 'created_at'
        ]
    
    def get_full_video_url(self, obj):
        """Zwraca pełny URL do wideo"""
        request = self.context.get('request')
        if request and obj.video_url:
            return obj.get_full_video_url(request)
        return None

# Serializer dla opcji odpowiedzi (closed questions)
class AnswerOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnswerOption
        fields = ['id', 'option_text', 'is_correct', 'display_order', 'question_id']

# Serializer dla opcji dopasowania (match questions)
class MatchOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = MatchOption
        fields = ['id', 'question', 'left_text', 'right_text', 'display_order', 'question_id']

# Serializer dla pytań (z opcjami)
class QuestionSerializer(serializers.ModelSerializer):
    options = AnswerOptionSerializer(many=True, read_only=True)
    match_options = MatchOptionSerializer(many=True, read_only=True)
    difficulty_level_name = serializers.CharField(source='difficulty_level.level_name', read_only=True)
    
    class Meta:
        model = Question
        fields = [
            'id', 'course', 'difficulty_level', 'difficulty_level_name',
            'question_type', 'question_text', 'correct_answer', 
            'points', 'explanation', 'options', 'match_options', 'created_at'
        ]

# Serializer dla postępu użytkownika
class UserCourseProgressSerializer(serializers.ModelSerializer):
    course_name = serializers.CharField(source='course.course_name', read_only=True)
    difficulty_level_name = serializers.CharField(source='current_difficulty_level.level_name', read_only=True)
    
    class Meta:
        model = UserCourseProgress
        fields = [
            'id', 'user', 'course', 'course_name', 'is_completed',
            'current_difficulty_level', 'difficulty_level_name',
            'correct_answers_count', 'total_attempts', 'points_earned',
            'video_watched', 'started_at', 'completed_at',
            # 🔥 NOWE POLA
            'fires_earned', 'fire_easy', 'fire_medium', 'fire_hard', 'fire_quiz'
        ]
        read_only_fields = ['user', 'started_at', 'fires_earned']

class SaveLearningProgressSerializer(serializers.Serializer):
    course_id = serializers.IntegerField(required=True)
    fire_easy = serializers.BooleanField(required=False, default=False)
    fire_medium = serializers.BooleanField(required=False, default=False)
    fire_hard = serializers.BooleanField(required=False, default=False)


class SaveQuizProgressSerializer(serializers.Serializer):
    course_id = serializers.IntegerField(required=True)
    passed = serializers.BooleanField(required=True)