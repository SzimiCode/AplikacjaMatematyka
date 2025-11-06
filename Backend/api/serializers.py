from rest_framework import serializers
from .models import Course, Question, AnswerOption, UserCourseProgress

# podstawowy serializer dla kursow - zwraca wszystkie pola
class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = '__all__'

# serializer dla opcji odpowiedzi - zwraca tylko to co potrzebne do wyswietlenia w quizie
class AnswerOptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = AnswerOption
        fields = ['id', 'option_text', 'is_correct']

# serializer dla pytan - laczy pytanie z jego opcjami odpowiedzi
class QuestionSerializer(serializers.ModelSerializer):
    # many=True bo jedno pytanie ma wiele opcji, read_only bo nie edytujemy opcji stad
    options = AnswerOptionSerializer(many=True, read_only=True)
    
    class Meta:
        model = Question
        # zwracamy text pytania, typ (otwarte/zamkniete), punkty i liste opcji
        fields = ['id', 'question_text', 'question_type', 'points', 'options']

# serializer dla postepu uzytkownika w kursie
class UserCourseProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserCourseProgress
        fields = '__all__'