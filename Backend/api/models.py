from django.db import models

# model uzytkownika aplikacji
class User(models.Model):
    nick = models.CharField(max_length=50, unique=True)  # nick musi byc unikalny
    email = models.EmailField(unique=True)  # email tez unikalny
    password_hash = models.CharField(max_length=255)  # zahashowane haslo
    dragon_name = models.CharField(max_length=50, default="Smoczek")  # nazwa smoka gracza
    total_points = models.IntegerField(default=0)  # suma punktow ze wszystkich kursow
    created_at = models.DateTimeField(auto_now_add=True)  # data rejestracji
    updated_at = models.DateTimeField(auto_now=True)  # ostatnia aktualizacja profilu
    
    def __str__(self):
        return self.nick

# klasa szkolna (np. klasa 1, 2, 3)
class Class(models.Model):
    class_name = models.CharField(max_length=50)  # np. "Klasa 1"
    description = models.TextField(blank=True)  # opcjonalny opis
    display_order = models.PositiveIntegerField(default=0)  # kolejnosc wyswietlania
    
    def __str__(self):
        return self.class_name

# kategoria w ramach klasy (np. algebra, geometria)
class Category(models.Model):
    class_fk = models.ForeignKey(Class, on_delete=models.CASCADE, related_name='categories')
    category_name = models.CharField(max_length=50)  # np. "Algebra"
    description = models.TextField(blank=True)
    icon_url = models.URLField(blank=True)  # link do ikonki kategorii
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.category_name

# kurs w ramach kategorii (np. "Rownania liniowe")
class Course(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='courses')
    course_name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    video_url = models.URLField(blank=True)  # link do materialu wideo
    video_duration = models.PositiveIntegerField(default=0)  # dlugosc w sekundach
    points_per_question = models.IntegerField(default=1)  # ile punktow za poprawna odpowiedz
    required_correct_answers = models.PositiveIntegerField(default=5)  # ile trzeba dobrych zeby ukonczyc
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.course_name

# poziom trudnosci pytan (latwy, sredni, trudny)
class DifficultyLevel(models.Model):
    level_name = models.CharField(max_length=50)  # np. "Latwy"
    level_code = models.CharField(max_length=20)  # np. "easy"
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.level_name

# pytanie w kursie
class Question(models.Model):
    QUESTION_TYPES = [
        ('open', 'Open'),  # pytanie otwarte
        ('closed', 'Closed'),  # pytanie zamkniete (tak/nie)
        ('multiple_choice', 'Multiple Choice'),  # wielokrotnego wyboru (abcd)
    ]
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='questions')
    difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    question_type = models.CharField(max_length=20, choices=QUESTION_TYPES)
    question_text = models.TextField()  # tresc pytania
    correct_answer = models.CharField(max_length=255)  # poprawna odpowiedz (backup dla pytan otwartych)
    points = models.IntegerField(default=1)  # ile punktow za to pytanie
    explanation = models.TextField(blank=True)  # wyjasnienie po udzieleniu odpowiedzi
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.question_text[:50]  # pokazuje pierwsze 50 znakow

# opcja odpowiedzi dla pytania (np. A, B, C, D)
class AnswerOption(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='options')
    option_text = models.CharField(max_length=255)  # tresc opcji
    is_correct = models.BooleanField(default=False)  # czy to poprawna odpowiedz
    display_order = models.PositiveIntegerField(default=0)  # kolejnosc (0=A, 1=B, itd)
    
    def __str__(self):
        return self.option_text

# postep uzytkownika w kursie
class UserCourseProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='progress')
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    is_completed = models.BooleanField(default=False)  # czy ukonczyl kurs
    current_difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    correct_answers_count = models.PositiveIntegerField(default=0)  # ile dobrych odpowiedzi
    total_attempts = models.PositiveIntegerField(default=0)  # ile prob ogolnie
    points_earned = models.IntegerField(default=0)  # zdobyte punkty w tym kursie
    video_watched = models.BooleanField(default=False)  # czy obejrzal material
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)  # data ukonczenia

# odpowiedz uzytkownika na pytanie
class UserAnswer(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    user_answer = models.TextField()  # co uzytkownik odpowiedzial
    is_correct = models.BooleanField(default=False)  # czy dobrze
    points_earned = models.IntegerField(default=0)  # ile dostal punktow
    time_spent = models.PositiveIntegerField(default=0)  # ile sekund zajelo mu odpowiedzenie
    answered_at = models.DateTimeField(auto_now_add=True)

# osiagniecie do zdobycia
class Achievement(models.Model):
    achievement_name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    icon_url = models.URLField(blank=True)
    points_reward = models.IntegerField(default=0)  # ile punktow za osiagniecie
    requirement_type = models.CharField(max_length=50)  # typ wymagania (np. "complete_courses")
    requirement_value = models.IntegerField(default=0)  # wartosc (np. 10 kursow)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.achievement_name

# odblokowane osiagniecia uzytkownika
class UserAchievement(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    achievement = models.ForeignKey(Achievement, on_delete=models.CASCADE)
    unlocked_at = models.DateTimeField(auto_now_add=True)  # kiedy zdobyl