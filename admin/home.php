<h1 class="">Welcome to <?php echo $_settings->info('name') ?></h1>
<hr>
<h1 style="color:brown;">Our Production stats</h1>

<!DOCTYPE html>
<html>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
<body>

<canvas id="myChart" style="width:100%;max-width:1200px"></canvas>

<script>
var xValues = ["SALES & MARKETING", "FINANCE", "ENGINEERING", "R&D", "HR"];
var yValues = [55, 49, 44, 24, 15];
var barColors = [
  "#b91d47",
  "#00aba9",
  "#2b5797",
  "#e8c3b9",
  "#1e7145"
];

new Chart("myChart", {
  type: "doughnut",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    title: {
      display: true,
      text: "Our Production stats"
    }
  }
});
</script>

</body>
</html>
