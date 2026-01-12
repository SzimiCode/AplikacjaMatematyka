from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

# menedzer do tworzenia użytkowników
class UserManager(BaseUserManager):
    def create_user(self, email, nick, password=None, **extra_fields):
        if not email:
            raise ValueError('Email jest wymagany')
        if not nick:
            raise ValueError('Nick jest wymagany')
        
        email = self.normalize_email(email)
        user = self.model(email=email, nick=nick, **extra_fields)
        user.set_password(password)  # automatyczne hashowanie
        user.save(using=self._db)
        return user
    
    def create_superuser(self, email, nick, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, nick, password, **extra_fields)

# model użytkownika aplikacji
class User(AbstractBaseUser, PermissionsMixin):
    nick = models.CharField(max_length=50, unique=True)
    email = models.EmailField(unique=True)
    full_name = models.CharField(max_length=100, blank=True)  # Imię i Nazwisko
    phone_number = models.CharField(max_length=20, blank=True)  # Numer telefonu
    dragon_name = models.CharField(max_length=50, default="Smoczek")
    total_points = models.IntegerField(default=0)
    
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    objects = UserManager()
    
    USERNAME_FIELD = 'email'  # logowanie przez email
    REQUIRED_FIELDS = ['nick']  # dodatkowe wymagane pola
    
    def __str__(self):
        return self.nick

# klasa szkolna (np. klasa 1, 2, 3)
class Class(models.Model):
    class_name = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.class_name

# kategoria w ramach klasy (np. algebra, geometria)
class Category(models.Model):
    class_fk = models.ForeignKey(Class, on_delete=models.CASCADE, related_name='categories')
    category_name = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    icon_url = models.URLField(blank=True)
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.category_name

# kurs w ramach kategorii (np. "Równania liniowe")
class Course(models.Model):
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='courses')
    course_name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    video_url = models.CharField(max_length=255, blank=True)
    points_per_question = models.IntegerField(default=1)
    required_correct_answers = models.PositiveIntegerField(default=5)
    display_order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.course_name
    
    def get_full_video_url(self, request):
        """Zwraca pełny URL do pliku wideo"""
        if self.video_url:
            return request.build_absolute_uri(f'/static/{self.video_url}')
        return None

# poziom trudności pytań (łatwy, średni, trudny)
class DifficultyLevel(models.Model):
    level_name = models.CharField(max_length=50)
    level_code = models.CharField(max_length=20)
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.level_name

# pytanie w kursie
class Question(models.Model):
    QUESTION_TYPES = [
        ('yesno', 'Yes/No'),
        ('closed', 'Closed'),
        ('enter', 'Enter'),
        ('match', 'Match'),    
    ]
    
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='questions')
    difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    question_type = models.CharField(max_length=20, choices=QUESTION_TYPES)
    question_text = models.TextField()
    correct_answer = models.CharField(max_length=255)
    points = models.IntegerField(default=1)
    explanation = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.question_text[:50]

# opcja odpowiedzi dla pytania (np. A, B, C, D)
class AnswerOption(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='options')
    option_text = models.CharField(max_length=255)
    is_correct = models.BooleanField(default=False)
    display_order = models.PositiveIntegerField(default=0)
    
    def __str__(self):
        return self.option_text

class MatchOption(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='match_options')
    left_text = models.CharField(max_length=255)   # element po lewej
    right_text = models.CharField(max_length=255)  # prawidłowe dopasowanie po prawej
    display_order = models.PositiveIntegerField(default=0)

# postęp użytkownika w kursie
class UserCourseProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='progress')
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    is_completed = models.BooleanField(default=False)
    current_difficulty_level = models.ForeignKey(DifficultyLevel, on_delete=models.SET_NULL, null=True)
    correct_answers_count = models.PositiveIntegerField(default=0)
    total_attempts = models.PositiveIntegerField(default=0)
    points_earned = models.IntegerField(default=0)
    video_watched = models.BooleanField(default=False)
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    fires_earned = models.IntegerField(default=0)
    fire_easy = models.BooleanField(default=False)
    fire_medium = models.BooleanField(default=False)
    fire_hard = models.BooleanField(default=False)
    fire_quiz = models.BooleanField(default=False)

    class Meta:
        unique_together = ['user', 'course']

    def update_fires_earned(self):
        """Aktualizuje sumę ogni na podstawie zdobytych ogni"""
        self.fires_earned = sum([
            self.fire_easy,
            self.fire_medium,
            self.fire_hard,
            self.fire_quiz,
        ])
        self.save()    

# odpowiedź użytkownika na pytanie
class UserAnswer(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    user_answer = models.TextField()
    is_correct = models.BooleanField(default=False)
    points_earned = models.IntegerField(default=0)
    time_spent = models.PositiveIntegerField(default=0)
    answered_at = models.DateTimeField(auto_now_add=True)