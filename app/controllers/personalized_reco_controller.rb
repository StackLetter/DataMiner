class PersonalizedRecoController < ApplicationController

  before_action :variables_init

  AB_TESTING_THRESHOLD_DAILY = 14
  AB_TESTING_THRESHOLD_WEEKLY = 2

  def index
    daily = @frequency == 'd'
    limit = MsaSection::SECTION_CONTENT_LIMIT
    max_sections = daily ? MsaDailyNewsletterSection::MAX_SECTIONS : MsaWeeklyNewsletterSection::MAX_SECTIONS
    badges_sections = daily ? MsaDailyNewsletterSection::BADGES_SECTIONS : MsaWeeklyNewsletterSection::BADGES_SECTIONS
    day = DateTime.now

    a_b_testing_threshold = daily ? AB_TESTING_THRESHOLD_DAILY : AB_TESTING_THRESHOLD_WEEKLY
    if @user.newsletters.size < a_b_testing_threshold
      redirect_to({controller: :trivial_reco, action: :index}.merge(recommendation_params))
      return
    end

    sections = daily ? @user.msa_segment.msa_daily_newsletter_sections.where('? >= msa_daily_newsletter_sections.from', day).where('? <= msa_daily_newsletter_sections.to', day).first
                   : @user.msa_segment.msa_weekly_newsletter_sections.where('? >= msa_weekly_newsletter_sections.from', day).where('? <= msa_weekly_newsletter_sections.to', day).first

    successful_sections = 0
    output = sections.sorted_sections[0..(max_sections + badges_sections)].inject([]) do |buf, wss|
      if successful_sections <= max_sections
        successful_sections += 1
        structure_condition = true

        section = MsaSection.find(wss)
        structure_condition = structure_condition && Badge.has_new_badge?(sections.from, sections.to, @user.site_id) if section.name == 'New badges'
        structure_condition = structure_condition && (@user.new_badges?(sections.from) || Badge.new_badges(sections.from, sections.to, @user.site_id).where(rank: 'gold').any?)  if section.name == 'Prestigious badges'
        if structure_condition
          msa_segment_section = @user.msa_segment.msa_segment_sections.find_by(section_id: wss)
          daily ? msa_segment_section.update(daily_newsletters_count: msa_segment_section.daily_newsletters_count.try(:+, 1) || 1) :
              msa_segment_section.update(weekly_newsletters_count: msa_segment_section.weekly_newsletters_count.try(:+, 1) || 1)

          buf << {
              content_type: section.content_type,
              custom: ['badge', 'cqa'].include?(section.content_type),
              name: section.name,
              description: section.description.gsub(/ ---- [QACB\-]/, ''),
              limit: limit,
              content_endpoint: section.content_endpoint + section.filter_query,
              section_id: section.id
          }
        end
      end

      buf
    end

    render json: output
  end

  def popular_unanswered
    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:question]) if @duplicates[:question]
    @questions = @questions.joins('left join answers on answers.question_id = questions.id').where('answers.question_id IS NULL')
    @questions = @questions.distinct.order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT * 5
      complement = Question.for_site(@user.site_id).existing
                       .where('questions.creation_date > ?', @max_from_date)
                       .order(score: :desc, creation_date: :asc)
                       .joins('left join answers on answers.question_id = questions.id')
                       .where('answers.question_id IS NULL')
                       .distinct
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:question] ? @questions.map(&:id) + @duplicates[:question] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def waiting_for_an_answer
    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:question]) if @duplicates[:question]
    @questions = @questions.joins('left join answers on answers.question_id = questions.id').where('answers.question_id IS NULL')
    @questions = @questions.distinct.order(score: :asc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT * 5
      complement = Question.for_site(@user.site_id).existing
                       .where('questions.creation_date > ?', @max_from_date)
                       .order(score: :asc, creation_date: :asc)
                       .joins('left join answers on answers.question_id = questions.id')
                       .where('answers.question_id IS NULL')
                       .distinct
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:question] ? @questions.map(&:id) + @duplicates[:question] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def useful_questions
    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:question]) if @duplicates[:question]
    @questions = @questions.joins('left join answers on answers.question_id = questions.id').where('answers.question_id IS NOT NULL')
    @questions = @questions.distinct.order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT * 5
      complement = Question.for_site(@user.site_id).existing
                       .where('questions.creation_date > ?', @max_from_date)
                       .order(score: :desc, creation_date: :asc)
                       .joins('left join answers on answers.question_id = questions.id')
                       .where('answers.question_id IS NOT NULL')
                       .distinct
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:question] ? @questions.map(&:id) + @duplicates[:question] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def hot_questions
    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:question]) if @duplicates[:question]
    @questions = @questions.distinct.order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT * 5
      complement = Question.for_site(@user.site_id).existing
                       .where('questions.creation_date > ?', @max_from_date)
                       .order(score: :desc, creation_date: :asc)
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:question] ? @questions.map(&:id) + @duplicates[:question] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def answers_you_may_be_interested_in
    @tags = @user.answers.map {|q| q.answer_tags.map(&:tag_id)}

    @answers = @tags.empty? ? nil : Answer.for_site(@user.site_id).existing.joins(:answer_tags).where('answers.creation_date > ?', @from_date).where(answer_tags: {tag_id: @tags})
    @answers = Answer.for_site(@user.site_id).existing.where('answers.creation_date > ?', @from_date) unless @answers
    @answers = @answers.where.not(id: @duplicates[:answer]) if @duplicates[:answer]
    @answers = @answers.distinct.order(score: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @answers.size < QUERY_LIMIT * 5
      complement = Answer.for_site(@user.site_id).existing
                       .where('answers.creation_date > ?', @max_from_date)
                       .order(score: :desc, creation_date: :asc)
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:answer] ? @answers.map(&:id) + @duplicates[:answer] : @answers.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@answers.to_a + complement.to_a, Site.find(@user.site_id), 'Answer')
  end

  def cqa_system_news
    questions_change = Question.where('created_at >= ?', @from_date).count
    answers_change = Answer.where('created_at >= ?', @from_date).count
    users_change = User.where('created_at >= ?', @from_date).count
    badges_change = Badge.where('created_at >= ?', @from_date).count

    render json: {questions_change: questions_change, answers_change: answers_change, badges_change: badges_change, users_change: users_change}
  end

  def highly_discussed_questions
    @questions = @tags.empty? ? nil : Question.for_site(@user.site_id).existing.joins(:question_tags).where('questions.creation_date > ?', @from_date).where(question_tags: {tag_id: @tags})
    @questions = Question.for_site(@user.site_id).existing.where('questions.creation_date > ?', @from_date) unless @questions
    @questions = @questions.where.not(id: @duplicates[:question]) if @duplicates[:question]
    @questions = @questions.distinct.where.not(comment_count: nil).order(comment_count: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @questions.size < QUERY_LIMIT * 5
      complement = Question.for_site(@user.site_id).existing
                       .where('questions.creation_date > ?', @max_from_date)
                       .where.not(comment_count: nil)
                       .order(comment_count: :desc, creation_date: :asc)
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:question] ? @questions.map(&:id) + @duplicates[:question] : @questions.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@questions.to_a + complement.to_a, Site.find(@user.site_id))
  end

  def highly_discussed_answers
    @tags = @user.answers.map {|q| q.answer_tags.map(&:tag_id)}

    @answers = @tags.empty? ? nil : Answer.for_site(@user.site_id).existing.joins(:answer_tags).where('answers.creation_date > ?', @from_date).where(answer_tags: {tag_id: @tags})
    @answers = Answer.for_site(@user.site_id).existing.where('answers.creation_date > ?', @from_date) unless @answers
    @answers = @answers.where.not(id: @duplicates[:answer]) if @duplicates[:answer]
    @answers = @answers.distinct.where.not(comment_count: nil).order(comment_count: :desc, creation_date: :asc).limit(QUERY_LIMIT)

    complement = []
    if @answers.size < QUERY_LIMIT * 5
      complement = Answer.for_site(@user.site_id).existing
                       .where('answers.creation_date > ?', @max_from_date)
                       .where.not(comment_count: nil)
                       .order(comment_count: :desc, creation_date: :asc)
                       .limit(QUERY_LIMIT * 5)
      where_not = @duplicates[:answer] ? @answers.map(&:id) + @duplicates[:answer] : @answers.map(&:id)
      complement = complement.where.not(id: where_not)
    end

    render json: filter_404_content(@answers.to_a + complement.to_a, Site.find(@user.site_id), 'Answer')
  end

  def new_badges
    new_badges = Badge.new_badges(@from_date, DateTime.now, @user.site_id)

    render json: {'congratulations': [], 'new_badges': new_badges.map(&:id)}
  end

  def prestigious_badges_count_change
    new_badges = Badge.new_badges(@from_date, DateTime.now, @user.site_id).where(rank: 'gold')
    users_new_badges = @user.user_badges.where('created_at >= ?', @from_date).map {|ub| ub.badge.id}

    render json: {'congratulations': users_new_badges, 'new_badges': new_badges.map(&:id)}
  end

  private

  def variables_init
    @user = User.includes(:user_tags, :user_favorites, questions: :question_tags).find(recommendation_params[:user_id])
    head 400 unless @user

    @frequency = recommendation_params[:frequency]
    @from_date = @frequency == 'd' ? 1.day.ago : 7.day.ago
    @max_from_date = @frequency == 'd' ? 7.day.ago : 12.day.ago

    @duplicates = recommendation_params[:duplicates] ? JSON.parse(URI.decode(recommendation_params[:duplicates])).deep_symbolize_keys : {}

    user_favorites_tags = @user.user_favorites.count == 0 ? [] :
                              Question.includes(:question_tags).where(external_id: @user.user_favorites.map(&:external_id)).map(&:question_tags).flatten.map(&:tag_id).uniq

    @tags = user_favorites_tags
    @tags << @user.user_tags.map(&:tag_id)
    @tags << @user.questions.map {|q| q.question_tags.map(&:tag_id)}
    @tags = @tags.flatten
    @tags = @tags.group_by {|tag| tag}.map {|tag_id, tags| [tags.size, tag_id]}.sort.reverse.map {|n| n[1]} # WARNING - remove map, and setup priority in DB queries
  end

  def recommendation_params
    params.permit(:user_id, :frequency, :duplicates, :domain)
  end

end