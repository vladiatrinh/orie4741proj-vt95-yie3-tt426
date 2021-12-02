library(ordinalNet)
library(caret)

train = read.csv("Data/train_values.csv")
test = read.csv("Data/train_labels.csv")

full = merge(x=train, y=test, by="building_id")
train_data = subset(full, select = -c(building_id, damage_grade))
test_data = full$damage_grade


numerical = c('count_floors_pre_eq', 'age', 'area_percentage', 'height_percentage', 'count_families')
categorical = c('land_surface_condition', 'foundation_type', 'roof_type', 'ground_floor_type', 'other_floor_type', 'position', 'plan_configuration', 'legal_ownership_status')
binary = c('has_superstructure_adobe_mud', 'has_superstructure_mud_mortar_stone', 'has_superstructure_stone_flag', 'has_superstructure_cement_mortar_stone', 'has_superstructure_mud_mortar_brick', 'has_superstructure_cement_mortar_brick', 'has_superstructure_timber', 'has_superstructure_bamboo', 'has_superstructure_rc_non_engineered', 'has_superstructure_rc_engineered', 'has_superstructure_other', 'has_secondary_use', 'has_secondary_use_agriculture', 'has_secondary_use_hotel', 'has_secondary_use_rental', 'has_secondary_use_institution', 'has_secondary_use_school', 'has_secondary_use_industry', 'has_secondary_use_health_post', 'has_secondary_use_gov_office', 'has_secondary_use_use_police', 'has_secondary_use_other', 'geo_level_1_id', 'geo_level_2_id', 'geo_level_3_id')

# numerical_data = subset(train_data, select= -categorical)
numerical_data = train_data[,!categorical]
categorical_data = train_data[,categorical]

dummy <- dummyVars(" ~ .", data=categorical_data)
one_hot <- data.frame(predict(dummy, newdata=categorical_data))
merge_df = merge(numerical_data, one_hot, by.x = 0, by.y = 0)

X_matrix = data.matrix(merge_df)
y_matrix = data.matrix(test_data)

# https://cran.r-project.org/web/packages/ordinalNet/ordinalNet.pdf
ordinal.lm = ordinalNet(X_matrix, y_matrix, family = "cumulative", link = "logit")
