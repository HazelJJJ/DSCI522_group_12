#comment
all :  doc/report.md src/project_eda.md

data/raw/default_of_credit_card_clients.feather : src/Download_data.py
		python src/Download_data.py --url=http://archive.ics.uci.edu/ml/machine-learning-databases/00350/default%20of%20credit%20card%20clients.xls --saving_path=data/raw/default_of_credit_card_clients.feather

data/processed/training.feather data/processed/test.feather : src/pre_process_cred.r data/raw/default_of_credit_card_clients.feather
		Rscript src/pre_process_cred.r --input=data/raw/default_of_credit_card_clients.feather --out_dir=data/processed

#make dir
results/correlation_plot.png results/density_plot.png results/education_histogram.png :  src/eda_cred.r  data/processed/training.feather
		Rscript src/eda_cred.r --train=data/processed/training.feather --out_dir=results
		
Rscript current.r --train=data/processed/training.feather --out_dir=results/density_plot.png

results/prediction_hp_results.csv results/prediction_prelim_results.csv : src/fit_predict_default_model.py data/processed/training.feather data/processed/test.feather
		python src/fit_predict_default_model.py --train_data="data/processed/training.feather" --test_data="data/processed/test.feather" --hp_out_dir="results/prediction_hp_results.csv" --prelim_results_dir="results/prediction_prelim_results.csv"

src/project_eda.md : data/raw/default_of_credit_card_clients.feather 
		 Rscript -e "markdown::render('src/project_eda.Rmd')"

doc/report.md : results/correlation_plot.png results/density_plot.png results/education_histogram.png results/prediction_hp_results.csv results/prediction_prelim_results.csv 
    Rscript -e "markdown::render('doc/report.Rmd')"
    
#add comments
clean : 
		rm -rf data/default_credit_card.csv
		rm -rf data/processed/training.feather 
		rm -rf data/processed/test.feather
		rm -rf results/correlation_plot.png 
		rm -rf results/density_plot.png 
		rm -rf results/education_histogram.png 
		rm -rf results/prediction_hp_results.csv
		rm -rf results/prediction_prelim_results.csv
		rm -rf src/project_eda.md
		rm -rf doc/report.md
		-rmdir results #TA will check 
		
#make results dir
#download to feather
#fix plots saving
	