setwd('/home/dataminer/DataMiner/app/jobs/bandit_jobs/R/')
#setwd('/home/msalat/School/DiplomaProject/DataMiner/app/jobs/bandit_jobs/R/')
source('./support_functions.R')

stackletter_users <- getCsv('../../../../tmp/stackletter_users.csv')
all_users <- getCsv('./all_data.csv')
model <- readRDS('./final_uc_8.md')

# BocCox
stackletter_users$answers_count <- boxCoxForStacklettterUsers(all_users, 'answers_count', stackletter_users)
stackletter_users$questions_count <- boxCoxForStacklettterUsers(all_users, 'questions_count', stackletter_users)
stackletter_users$comments_count <- boxCoxForStacklettterUsers(all_users, 'comments_count', stackletter_users)
stackletter_users$user_badges_count <- boxCoxForStacklettterUsers(all_users, 'user_badges_count', stackletter_users)
stackletter_users$user_tags_count <- boxCoxForStacklettterUsers(all_users, 'user_tags_count', stackletter_users)
stackletter_users$question_tags_count <- boxCoxForStacklettterUsers(all_users, 'question_tags_count', stackletter_users)
stackletter_users$answer_tags_count <- boxCoxForStacklettterUsers(all_users, 'answer_tags_count', stackletter_users)
stackletter_users$mu_questions <- boxCoxForStacklettterUsers(all_users, 'mu_questions', stackletter_users)
stackletter_users$reputation <- boxCoxForStacklettterUsers(all_users, 'reputation', stackletter_users)

all_users$answers_count <- boxCox(all_users, 'answers_count')
all_users$questions_count <- boxCox(all_users, 'questions_count')
all_users$comments_count <- boxCox(all_users, 'comments_count')
all_users$user_badges_count <- boxCox(all_users, 'user_badges_count')
all_users$user_tags_count <- boxCox(all_users, 'user_tags_count')
all_users$question_tags_count <- boxCox(all_users, 'question_tags_count')
all_users$answer_tags_count <- boxCox(all_users, 'answer_tags_count')
all_users$mu_questions <- boxCox(all_users, 'mu_questions')
all_users$reputation <- boxCox(all_users, 'reputation')

# Min-Max
stackletter_users$questions_count <- min_maxForStackLetterUsers(all_users$questions_count, stackletter_users$questions_count)
stackletter_users$answers_count <- min_maxForStackLetterUsers(all_users$answers_count, stackletter_users$answers_count)
stackletter_users$comments_count <- min_maxForStackLetterUsers(all_users$comments_count, stackletter_users$comments_count)
stackletter_users$user_badges_count <- min_maxForStackLetterUsers(all_users$user_badges_count, stackletter_users$user_badges_count)
stackletter_users$user_tags_count <- min_maxForStackLetterUsers(all_users$user_tags_count, stackletter_users$user_tags_count)
stackletter_users$question_tags_count <- min_maxForStackLetterUsers(all_users$question_tags_count, stackletter_users$question_tags_count)
stackletter_users$answer_tags_count <- min_maxForStackLetterUsers(all_users$answer_tags_count, stackletter_users$answer_tags_count)
stackletter_users$mu_questions <- min_maxForStackLetterUsers(all_users$mu_questions, stackletter_users$mu_questions)
stackletter_users$mu_answers <- min_maxForStackLetterUsers(all_users$mu_answers, stackletter_users$mu_answers)
stackletter_users$mu_comments <- min_maxForStackLetterUsers(all_users$mu_comments, stackletter_users$mu_comments)
stackletter_users$expertise <- min_maxForStackLetterUsers(all_users$expertise, stackletter_users$expertise)
stackletter_users$reputation <- min_maxForStackLetterUsers(all_users$reputation, stackletter_users$reputation)

segments <- c()
for(row in 1:nrow(stackletter_users)){
  new_segment <- cl_predict(model, stackletter_users[row, 3:ncol(stackletter_users)])
  
  segments = c(segments, new_segment)
}

segments_data <- data.table(stackletter_users$id, segments)
saveCsv(segments_data, '../../../../tmp/stackletter_users_with_segments.csv')
