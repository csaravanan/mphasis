window.onload = function()
{
$(function () {
        $('#auditcompliancerating').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: domains
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Percentage'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} %</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: 'Domains',
                data: percentages

            }]
        });
    });

$(function () {
        $('#ISMSAuditScore').highcharts({
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Maximum Score and Actual Score'
            },
            subtitle: {
                text: ''
            },
            xAxis: {
                categories: domains,
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Value',
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                valueSuffix: ' '
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -40,
                y: 100,
                floating: true,
                borderWidth: 1,
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: [{
                name: 'Weightage',
                data: weightages
            }, {
                name: 'Maximum scores',
                data: maximum_scores
            }]
        });
    });

		$(function () {
				Highcharts.data({
        csv: document.getElementById('tsv').innerHTML,
        itemDelimiter: '\t',
        parsed: function (columns) {
                drilldownSeries = [];
            // Create the chart
                 $('#container').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: 'Audit Status'
                },
                subtitle: {
                    text: ''
                },
                plotOptions: {
                    series: {
                        dataLabels: {
                            enabled: true,
                            format: '{point.name}: {point.y:.1f}%'
                        }
                    }
                },

                tooltip: {
                    headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
                    //~ pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
                },

						 series: [{
						name: 'Audit status',
						colorByPoint: true,
						data: [{
            name: 'Completed',
            y: completed_status,
            drilldown: 'completed'
						}, {
            name: 'Pending',
            y: pending_status,
            drilldown: 'pending'
						}]
					}],
							drilldown: {
						series: [{
								id: 'completed',
								name: 'Completed',
								data: [['Recommendation', recommendation_completed_count],
										['Response', response_completed_count],
										['Observation', observation_completed_count]
								]
						}, {
								id: 'pending',
								name: 'pending',
								data: [ ['Recommendation', recommendation_pending_count],
										['Response', response_pending_count],
										['Observation', observation_pending_count]
								]
						}]
				}
				})


        }
    });
});
}