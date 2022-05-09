# import libraries
from SALib.analyze import fast,sobol
from SALib.plotting.bar import plot as barplot
import pandas as pd
import shutil
import numpy as np
import matplotlib.pyplot as plt
import plotly.graph_objects as go
import plotly.express as px
import re

class Sensitivity:
    
    def __init__(self, problem, Y, X):
        
        self.problem = problem
        self.outcome = Y.name
        self.vars = list(X.columns)
        self.Y = Y.to_numpy()
        self.X = X
 
    def score(self, type):
        self.type = type
        if (self.type == 'efast'):
            self.Sif = fast.analyze(self.problem, self.Y, print_to_console=True)
        if (self.type == 'sobol'):
            self.Sif = sobol.analyze(self.problem, self.Y, print_to_console=True)

    def plot(self, save=False, filepath = '', move = False, moving_path = ''):
        if (self.type == 'efast'):
            self.Sif.plot()
            if (save):
                plt.savefig(filepath, bbox_inches='tight')   
                plt.savefig(filepath, bbox_inches='tight')
            if (move):
                shutil.copy(filepath, moving_path)
        if (self.type == 'sobol'):
            total, first, second = self.Sif.to_df()
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

    def plot3D(self, labels=None, save=False, filepath='', move=False, moving_path=''):
        
        if (labels==None):
            labels = {
                'outcome' : self.outcome,
                'x' : self.vars[0],
                'y' : self.vars[1],
                'z' : self.vars[2]
            }

        df =self.X.copy()
        df[self.outcome] = self.Y

        fig = px.scatter_3d(df, x=self.vars[0], y=self.vars[1], z=self.vars[2],
            color=self.outcome, 
            color_continuous_scale = px.colors.sequential.OrRd)

        fig.update_traces(marker=dict(size=4, opacity = 0.7),
             selector=dict(mode='markers'))
        fig.update_layout(scene = dict(
            xaxis_title=labels['x'],
            yaxis_title=labels['y'],
            zaxis_title=labels['z']),
            width=700,
            margin=dict(r=20, b=10, l=10, t=10), 
            coloraxis_colorbar=dict(title=labels['outcome'])
            )
        fig.show()

        if (save):
            fig.write_image(filepath)
            if (move):
                shutil.copy(filepath, moving_path)

    def tabval(self, type='ST'):
        p = self.Sif['ST']
        params = len(p)
        v = []
        for i in range(0,params):
            p = self.Sif[type][i]
            c = self.Sif[type + '_conf'][i]
            l = p - c
            h = p + c
            v.append(str(format(p,'.3f')) + " [" + str(format(l,'.3f')) + "; " + str(format(h,'.3f')) + "]")
        return v

    def createRows(self, d, g=['s1', 'st']):
        rows = {}
        for i in g:
            v = {}
            h = 0
            for ii in self.Sif['names']:
                v[ii] = [value[h] for key, value in d.items() if key.endswith(i)]
                h += 1
            rows[i] = "\\\\ \n\t".join(["{} & {}".format("\\hspace{1.5em} " + _k, " & ".join(_v)) for _k, _v in v.items()])
        return rows