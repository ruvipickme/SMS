<?php
require_once('../../config.php');
if(isset($_GET['id']) && $_GET['id'] > 0){
    $qry = $conn->query("SELECT * from `work_monitor` where id = '{$_GET['id']}' ");
    if($qry->num_rows > 0){
        foreach($qry->fetch_assoc() as $k => $v){
            $$k=$v;
        }
    }
}

$qry2 = $conn->query("SELECT * from `supplier_list` where status = 1");

?>
<style>
	img#cimg{
		height: 15vh;
		width: 15vh;
		object-fit: scale-down;
		object-position: center center;
	}
</style>
<div class="container-fluid">
	<form action="" id="workshop-form">
		<input type="hidden" name ="id" value="<?php echo isset($id) ? $id : '' ?>">
		<div class="form-group">
			<label for="name" class="control-label">Workshop Name</label>
<!--			<input  class="form-control rounded-0" value="--><?php //echo isset($name) ? $name : ''; ?><!--">-->
            <select name="name" id="name" class="form-control">
                <?php
                  if($qry2->num_rows > 0){
                      while ($row = mysqli_fetch_assoc($qry2)) {
                  ?>
                        <option <?php echo (isset($name) && $name == $row['name'])?'selected':'' ?> value="<?php echo $row['name']; ?>"><?php echo $row['name']; ?></>
                  <?php }
                  }
                  ?>
            </select>
		</div>
		<div class="form-group">
			<label for="address" class="control-label">Address</label>
			<textarea name="address" id="address" cols="30" rows="2" class="form-control form no-resize"><?php echo isset($address) ? $address : ''; ?></textarea>
		</div>
		<div class="form-group">
			<label for="cperson" class="control-label">Assigned Person</label>
			<input name="aperson" id="aperson" class="form-control rounded-0" value="<?php echo isset($aperson) ? $aperson : ''; ?>">
		</div>
		<div class="form-group">
			<label for="contact" class="control-label">Contact #</label>
			<input name="contact" id="contact" class="form-control rounded-0" value="<?php echo isset($contact) ? $contact : ''; ?>">
		</div>
		<div class="form-group">
			<label for="status" class="control-label">Status</label>
			<select name="status" id="status" class="custom-select selevt">
			<option value="1" <?php echo isset($status) && $status == 1 ? 'selected' : '' ?>>Done</option>
			<option value="0" <?php echo isset($status) && $status == 0 ? 'selected' : '' ?>>Pending</option>
			</select>
		</div>
	</form>
</div>
<script>
	$(document).ready(function(){
		$('#workshop-form').submit(function(e){
			e.preventDefault();
            var _this = $(this)
			 $('.err-msg').remove();
			start_loader();
			$.ajax({
				url:_base_url_+"classes/Master.php?f=save_workshop",
				data: new FormData($(this)[0]),
                cache: false,
                contentType: false,
                processData: false,
                method: 'POST',
                type: 'POST',
                dataType: 'json',
				error:err=>{
					console.log(err)
					alert_toast("An error occured",'error');
					end_loader();
				},
				success:function(resp){
					if(typeof resp =='object' && resp.status == 'success'){
						location.reload();
					}else if(resp.status == 'failed' && !!resp.msg){
                        var el = $('<div>')
                            el.addClass("alert alert-danger err-msg").text(resp.msg)
                            _this.prepend(el)
                            el.show('slow')
                            end_loader()
                    }else{
						alert_toast("An error occured",'error');
						end_loader();
                        console.log(resp)
					}
				}
			})
		})
	})
</script>