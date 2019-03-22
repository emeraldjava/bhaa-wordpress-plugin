<ul class="nav">
<?php
$race_url = get_permalink(get_the_ID());
?>
<!--  <li class="nav-item"><a class="nav-link" href="<php echo $race_url;?>/overview">Overview</a></li>-->
  <li class="nav-item"><a class="nav-link" href="<?php echo $race_url;?>">Results</a></li>
  <li class="nav-item"><a class="nav-link" href="<?php echo $race_url;?>teams">Teams</a></li>
<!--  <li class="nav-item"><a class="nav-link" href="<php echo $race_url;?>/awards">Awards</a></li>-->
<!--  <li class="nav-item"><a class="nav-link" href="<php echo $race_url;?>/standards">Standards</a></li>-->
</ul>
