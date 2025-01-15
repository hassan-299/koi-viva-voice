class QuizMailer < ApplicationMailer
  def quiz_created_email(student, quiz)
    @quiz = quiz
    @questions = quiz.questions
    @student = student
    mail(
      to: student,
      subject: "New Quiz Created: #{@quiz.title}"
    )
  end

  def quiz_marked(student, quiz, grade)
    @student = student
    @quiz = quiz
    @grade = grade

    mail(
      to: @student.email,
      subject: "Your Quiz '#{@quiz.title}' has been marked!"
    )
  end

  def quiz_submitted(teacher, student, quiz)
    @teacher = teacher
    @student = student
    @quiz = quiz

    mail(
      to: @teacher.email,
      subject: "Student '<%= @student.name %>' Submitted Quiz '<%= @quiz.title %>'"
    )
  end
end
