# efast function
def efast(y, problem, save=False, filepath = '', move = False, moving_path = ''):
    
    # import libraries
    from SALib.analyze import fast
    from SALib.plotting.bar import plot as barplot
    import pandas as pd
    import shutil
    import numpy as np
    import matplotlib.pyplot as plt

    # process data
    y = y.to_numpy()

    # efast
    Sif = fast.analyze(problem, y, print_to_console=True)

    # plots
    Sif.plot()
    if (save):
        plt.savefig(filepath, bbox_inches='tight')   
        plt.savefig(filepath, bbox_inches='tight')
        if (move):
            shutil.copy(filepath, moving_path)

# sobol function
def sobol(y, problem, save=False, filepath = '', move = False, moving_path = ''):
    # import libraries
    from SALib.analyze import sobol
    from SALib.plotting.bar import plot as barplot
    import pandas as pdz
    import shutil
    import numpy as np
    import matplotlib.pyplot as plt
    import re 

    # process data
    y = y.to_numpy()

    # sobol
    Si = sobol.analyze(problem, y, print_to_console=True)
    total, first, second = Si.to_df()

    # plots
    v = ['st', 's1', 's2']
    st = barplot(total)
    s1 = barplot(first)
    s2 = barplot(second)

    if (save): 
        for i in v:
            tpath = re.sub('\.pdf', '-' + i + '.pdf', filepath)
            plt.savefig(tpath, bbox_inches='tight')
            if (move): 
                shutil.copy(tpath, moving_path)


def plot3d(df, outcome, x, y, z, labels, save=False, filepath = '', move = False, moving_path = ''):

    import plotly.express as px
    import shutil
    fig = px.scatter_3d(df, x=x, y=y, z=z,
                color=outcome, 
                color_continuous_scale = px.colors.sequential.OrRd)

    fig.update_traces(marker=dict(size=4, opacity = 0.7),
                         selector=dict(mode='markers'))
    fig.update_layout(scene = dict(
                    xaxis_title=labels["x"],
                    yaxis_title=labels["y"],
                    zaxis_title=labels["z"]),
                    width=700,
                    margin=dict(r=20, b=10, l=10, t=10), 
                    coloraxis_colorbar=dict(title=labels["outcome"])
                    )
    fig.show()

    if (save):
        fig.write_image(filepath)
        if (move):
            shutil.copy(filepath, moving_path)