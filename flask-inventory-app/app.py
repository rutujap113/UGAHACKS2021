from flask import Flask, render_template, url_for, request, redirect
from flask_sqlalchemy import SQLAlchemy
from collections import defaultdict
from datetime import datetime
import random
from bokeh.models import (HoverTool, FactorRange, Plot, LinearAxis, Grid, Range1d)
from bokeh.models.glyphs import VBar
from bokeh.plotting import figure
from bokeh.charts import Bar
from bokeh.embed import components
from bokeh.models.sources import ColumnDataSource
from ncr import NCRRequester

app = Flask(__name__)
ncr = NCRRequester()


@app.route('/', methods=["POST", "GET"])
def index():
    items = ncr.getIngredients()
    names = items.keys()
    counts = [item['count'] for item in items.values()]
    return render_template("index.html", items = items)

@app.route('/delivery/', methods=["POST", "GET"])
def delivery():
    return render_template("delivery.html", locations = [])

@app.route('/catalog/', methods=["POST", "GET"])
def viewCatalog():
    items = ncr.getIngredients()
    menu = ncr.getMenu()
    names = items.keys()
    counts = [item['count'] for item in items.values()]
    return render_template("catalog.html", items = items)

@app.route("/orders/", methods=["POST", "GET"])
def orders():
    return render_template("orders.html", movements=[])


def create_hover_tool():
    """Generates the HTML for the Bokeh's hover data tool on our graph."""
    hover_html = """
      <div>
        <span class="hover-tooltip">$x</span>
      </div>
      <div>
        <span class="hover-tooltip">@bugs</span>
      </div>
      <div>
        <span class="hover-tooltip">@costs{0.00}</span>
      </div>
    """
    return HoverTool(tooltips=hover_html)

def create_bar_chart(data, title, x_name, y_name, hover_tool=None,
                     width=1200, height=300):
    """Creates a bar chart plot with the exact styling for the centcom
       dashboard. Pass in data as a dictionary, desired plot title,
       name of x axis, y axis and the hover tool HTML.
    """
    source = ColumnDataSource(data)
    xdr = FactorRange(factors=data[x_name])
    ydr = Range1d(start=0,end=max(data[y_name])*1.5)

    tools = []
    if hover_tool:
        tools = [hover_tool,]

    plot = figure(title=title, x_range=xdr, y_range=ydr, plot_width=width,
                  plot_height=height, h_symmetry=False, v_symmetry=False,
                  min_border=0, toolbar_location="above", tools=tools,
                  responsive=True, outline_line_color="#666666")

    glyph = VBar(x=x_name, top=y_name, bottom=0, width=.8,
                 fill_color="#0f110f")
    plot.add_glyph(source, glyph)

    xaxis = LinearAxis()
    yaxis = LinearAxis()

    plot.add_layout(Grid(dimension=0, ticker=xaxis.ticker))
    plot.add_layout(Grid(dimension=1, ticker=yaxis.ticker))
    plot.toolbar.logo = None
    plot.min_border_top = 0
    plot.xgrid.grid_line_color = None
    plot.ygrid.grid_line_color = "#999999"
    plot.yaxis.axis_label = "Quantity"
    plot.ygrid.grid_line_alpha = 0.1
    plot.xaxis.axis_label = "Inventory List"
    plot.xaxis.major_label_orientation = 1
    return plot

@app.route("/analytics/", methods=["POST", "GET"])
def analytics():
    bars_count = 15
    data = {'days':[], 'bugs':[], 'costs':[]}

    for i in range(1, bars_count+1):
        data['days'].append(i)
        data['bugs'].append(random.randint(1,100))
        data['costs'].append(random.randint(1,1000))
        hover = create_hover_tool()
        plot = create_bar_chart(data, "Inventory Data in the Last 12 days", "days","bugs", hover)
        script, div = components(plot)
    return render_template("movements.html", bars_count = bars_count, the_div = div, the_script = script)





if (__name__ == "__main__"):
    app.run(debug=True)
