/**
 * ClsWrappers contains all wrapper and DTO classes.
 *
 * @author  Lingjun Jiang
 * @created 2014-06-06
 * @version 1.0
 * @since   28.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2014-06-06 Lingjun Jiang <lingjun.jiang@itbconsult.com>
 * - Created
 */

global class ClsWrappers {

    public class TriggerContext {
        
        public Boolean isBefore {get; set {
            this.isBefore = value;
            if (value) this.isAfter = false;
        }}
        public Boolean isAfter {get; set {
            this.isAfter = value;
            if (value) this.isBefore = false;
        }}
        public Boolean isInsert {get; set {
            this.isInsert = value;
            if (value) {
                this.isUpdate = false;
                this.isDelete = false;
                this.isundelete = false;
            }
        }}
        public Boolean isUpdate {get; set {
            this.isUpdate = value;
            if (value) {
                this.isInsert = false;
                this.isDelete = false;
                this.isundelete = false;
            }
        }}
        public Boolean isDelete {get; set {
            this.isDelete = value;
            if (value) {
                this.isInsert = false;
                this.isUpdate = false;
                this.isundelete = false;
            }
        }}
        public Boolean isUndelete {get; set {
            this.isUndelete = value;
            if (value) {
                this.isInsert = false;
                this.isUpdate = false;
                this.isDelete = false;
            }
        }}
        public List<SObject> newList {get; set;}
        public Map<Id, SObject> newMap {get; set;}
        public List<SObject> oldList {get; set;}
        public Map<Id, SObject> oldMap {get; set;}
        
        public TriggerContext() {}
        
        public TriggerContext(Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
                                List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap) {
            this.isBefore = isBefore;
            this.isAfter = isAfter;
            this.isInsert = isInsert;
            this.isUpdate = isUpdate;
            this.isDelete = isDelete;
            this.isUndelete = isUndelete;
            this.newList = newList;
            this.newMap = newMap;
            this.oldList = oldList;
            this.oldMap = oldMap;
        }
    }
    
}