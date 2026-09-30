import * as Rbase from "../rbase_common.js"
import { RbaseController } from "../rbase_stimulus.js"

export default class extends RbaseController {
  connect() {
    super.connect();
    $('table tbody tr').click(function(){
      var id = $(this).attr("data-id");
        location.href = '/top/' + id;
    });
  }
}
