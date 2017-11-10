class RecommendationController < ApplicationController

  before_action :variables_init

  QUERY_LIMIT = 10

  def index
    daily = @frequency == 'd'
    limit = daily ? 2 : 5

    top_new_questions = {
        content_type: 'question',
        name: 'Top new questions',
        description: 'The most interesting questions selected by your activity in various tags and their creation date.',
        limit: limit,
        content_endpoint: URI.unescape(top_new_questions_url(user_id: '%1$s', frequency: '%2$s', duplicates: '%3$s'))
    }

    greatest_hits = {
        content_type: 'question',
        name: "Greatest hits from previous #{daily ? 'week' : 'weeks'}",
        description: 'Valuable questions from the last week selected by your activity in various tags and their score.',
        limit: limit,
        content_endpoint: URI.unescape(greatest_hits_url(user_id: '%1$s', frequency: '%2$s', duplicates: '%3$s'))
    }

    answer_these = {
        content_type: 'question',
        name: 'Can you answer these?',
        description: 'Unanswered questions selected by your activity in various tags.',
        limit: limit,
        content_endpoint: URI.unescape(answer_these_url(user_id: '%1$s', frequency: '%2$s', duplicates: '%3$s'))
    }

    to_return = [top_new_questions, greatest_hits, answer_these]
    render json: to_return
  end

  def top_new_questions
    head 400 if !@user

    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:questions]) if @duplicates[:questions]
    @questions = @questions.distinct.order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT
      complement = Question.for_site(@user.site_id).existing.joins(:question_tags)
                       .where('questions.creation_date > ?', @max_from_date)
                       .where(question_tags: {tag_id: @tags})
                       .order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT - @questions.size)
      where_not = @duplicates[:questions] ? @questions.map(&:id) + @duplicates[:questions] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def greatest_hits
    head 400 if !@user

    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:questions]) if @duplicates[:questions]
    @questions = @questions.distinct.order(score: :desc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT
      complement = Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', (@frequency == 'd' ? 7.day.ago : 21.day.ago)).where(question_tags: {tag_id: @tags}).order(score: :desc).limit(QUERY_LIMIT - @questions.size)
      where_not = @duplicates[:questions] ? @questions.map(&:id) + @duplicates[:questions] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def answer_these
    head 400 if !@user

    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins('LEFT JOIN answers ON questions.id = answers.question_id').joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags}).where('answers.question_id IS NULL') unless @tags.empty?
    @questions = Question.for_site(@user.site_id).existing.joins('LEFT JOIN answers ON questions.id = answers.question_id').where('questions.creation_date > ?', @from_date).where('answers.question_id IS NULL') unless @questions
    @questions = @questions.where.not(id: @duplicates[:questions]) if @duplicates[:questions]
    @questions = @questions.order('RANDOM()').limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT
      complement = Question.for_site(@user.site_id).existing.joins('LEFT JOIN answers ON questions.id = answers.question_id').joins(:question_tags).where('questions.creation_date > ?', @max_from_date).where(question_tags: {tag_id: @tags}).where('answers.question_id IS NULL')
      where_not = @duplicates[:questions] ? @questions.map(&:id) + @duplicates[:questions] : @questions.map(&:id)
      complement = complement.where.not(id: where_not).order('RANDOM()').limit(10)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  private

  def variables_init
    @user = User.includes(:user_tags, questions: :question_tags).find(recommendation_params[:user_id])

    @frequency = recommendation_params[:frequency]
    @from_date = @frequency == 'd' ? 1.day.ago : 7.day.ago
    @max_from_date = @frequency == 'd' ? 7.day.ago : 21.day.ago

    @duplicates = recommendation_params[:duplicates] ? JSON.parse(URI.decode(recommendation_params[:duplicates])).symbolize_keys : {}

    @tags = @user.user_tags.map(&:tag_id)
    @tags << @user.questions.map {|q| q.question_tags.map(&:tag_id)}
    @tags = @tags.flatten
    @tags = @tags.group_by {|tag| tag}.map {|tag_id, tags| [tags.size, tag_id]}.sort.reverse.map {|n| n[1]} # WARNING - remove map, and setup priority in DB queries
  end

  def recommendation_params
    params.permit(:user_id, :frequency, :duplicates, :domain)
  end

end
