raw_train = read.csv('Data/train_values.csv')
raw_label = read.csv('Data/train_labels.csv')

full_data = merge(raw_train, raw_label, by="building_id")

land_damage = table(full_data$land_surface_condition, full_data$damage_grade)
foundation_damage = table(full_data$foundation_type, full_data$damage_grade)
other_floor_type_damage = table(full_data$other_floor_type, full_data$damage_grade)

chisq.test(land_damage)
chisq.test(foundation_damage)
chisq.test(other_floor_type_damage)