from rest_framework import serializers
from .models import Course, Question, AnswerOption, UserCourseProgress, User
from django.contrib.auth.password_validation import validate_password

# Serializer do rejestracji
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

# Serializer użytkownika (do zwracania danych po logowaniu)
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'email', 'nick', 'full_name', 'phone_number', 'dragon_name', 'total_points', 'created_at']
        read_only_fields = ['id', 'created_at']

# Serializer do logowania
class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

# podstawowy serializer dla kursów
class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'

# serializer dla opcji odpowiedzi
class AnswerOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnswerOption
        fields = ['id', 'option_text', 'is_correct']

# serializer dla pytań
class QuestionSerializer(serializers.ModelSerializer):
    options = AnswerOptionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Question
        fields = ['id', 'question_text', 'question_type', 'points', 'options']

# serializer dla postępu użytkownika
class UserCourseProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCourseProgress
        fields = '__all__'