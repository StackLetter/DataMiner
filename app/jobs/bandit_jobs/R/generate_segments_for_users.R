setwd('/home/msalat/School/DiplomaProject/DataMiner/app/jobs/bandit_jobs/R/')
source('./support_functions.R')

stackletter_users <- getCsv('../../../../tmp/stackletter_users.csv')
model <- readRDS('./final_uc_8.md')

segments <- c()
for(row in 1:nrow(stackletter_users)){
  new_segment <- cl_predict(model, stackletter_users[row, 3:ncol(stackletter_users)])
  segments = c(segments, new_segment)
}

segments_data <- data.table(stackletter_users$id, segments)
saveCsv(segments_data, '../../../../tmp/stackletter_users_with_segments.csv')
