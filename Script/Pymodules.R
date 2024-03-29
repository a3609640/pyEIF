library(reticulate)
py_version()
py_list_packages()
py_config()
conda_list()
py_install("python-louvain", method = "conda", pip = TRUE)
py_install("fastcluster", method = "conda")
py_install("lifelines", method = "conda")
py_install("matplotlib", method = "conda")
py_install("matplotlib_venn", method = "conda", pip = TRUE)
py_install("mygene", method = "conda", pip = TRUE)
py_install("networkx", method = "conda")
py_install("numpy", method = "conda")
py_install("pylab", method = "conda")
py_install("seaborn", method = "conda")
py_install("scipy", method = "conda")
py_install("umap", method = "conda", pip = TRUE)

py_install("heatmap-grammar", method = "conda", pip = TRUE)
py_install("bioinfokit", method = "conda", pip = TRUE)
py_install("statannot", method = "conda")

py_install("absl", method = "conda")
py_install("gseapy", method = "conda", pip = TRUE)
py_install("plot_likert", method = "conda", pip = TRUE)



