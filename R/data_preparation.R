#' @title Reduce cardinality in categorical variable by automatic grouping
#' @description Reduce the cardinality of an input variable based on a target -binary for now- variable based on attribitues of
#' accuracy and representativity, for both input and target variable. It uses a cluster model to create the new groups
#' @param data data frame source
#' @param input categorical variable indicating
#' @param target string of the variable to optimize the re-grouping
#' @param n_groups number of groups for the new category based on str_input, normally between ~3 and ~10.
#' @param seed optional, random number used internally for the k-means, changing this value will change the model
#' @examples
#' # Reducing quantity of countries based on has_flu variable
#' auto_grouping(data=data_country, input='country', target="has_flu", n_groups=8)
#' @return A list containing 3 elements: recateg_results which contains the description of the target variable with the new groups;
#' df_equivalence is a data frame containing the str_input category and the new category; fit_cluster which is the cluster model used to do the re-grouping
#' @export
auto_grouping <- function(data, input, target, n_groups, seed=999)
{
	# target="has_flu";input='country';data=data_country
	data[, input]=as.character(data[, input])

	df_categ=categ_analysis(data, input , target)

	d=select_(df_categ, "sum_target", "mean_target", "perc_rows")

	set.seed(seed)
	fit_cluster=kmeans(scale(data.frame(d)), n_groups)
	fit_cluster$centers;fit_cluster$size

	## Equivalence table
	var_rec=paste(input, "rec", sep="_")
	df_categ[, var_rec]=paste("group_", fit_cluster$cluster, sep = "")

	## See new profiling based on new groups
	data_rec=merge(select_(data, input, target), select_(df_categ, input, var_rec), by=input)
	recateg_results=categ_analysis(data_rec, var_rec, target)

	l_res=list()
	l_res$recateg_results=recateg_results
	l_res$df_equivalence=arrange_(unique(select_(data_rec, input, var_rec)), var_rec)
	l_res$fit_cluster=fit_cluster

	return(l_res)
}