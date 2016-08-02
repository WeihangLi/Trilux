/**
 * A virtual implementation which implements IntTrigger to provide each method a default implementation.
 * It also provides a template method for triggerBefore and triggerAfter and several methods in smaller
 * granularity, such as beforeInsert, beforeUpdate, beforeDelete, afterInsert, afterUpdate and afterDelete,
 * so that any handler could inherit it and implement parts of the methods instead of implementing all of them.
 *  
 * @author Lingjun Jiang
 * @created 2014-06-07
 * @version 1.0
 * @since 28.0
 *
 * @changelog
 * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
 * - Created
 */
 
public virtual class ClsTriggerVirtual implements IntTrigger {
    
    /** the map which catchs RecordType for the whole trigger chain to use */
    public static Map<String, Map<String, Id>> map_objName_rtDevName_rtId;
    
    /**
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     *
     * The default implementation of this method would deal with the records in smaller granularity.
     * It can be overriden directly by any handlers if the business logic is relately complex.
     * Otherwise, handlers could override any precise method, like beforeInsert, beforeUpdate
     * and beforeDelete for ease. 
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        // Iterate through the records to be deleted passing them to the handler.
        if (trgCtx.isDelete) {
            for (SObject so : trgCtx.oldList) {
                this.beforeDelete(so);
            }
        }
        
        // Iterate through the records to be inserted passing them to the handler.
        else if (trgCtx.isInsert) {
            for (SObject so : trgCtx.newList) {
                this.beforeInsert(so);
            }
        }
        
        // Iterate through the records to be updated passing them to the handler.
        else if (trgCtx.isUpdate) {
            for (SObject so : trgCtx.oldList) {
                this.beforeUpdate(so, trgCtx.newMap.get(so.Id));
            }
        }
        
    }
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     *
     * The default implementation of this method would deal with the records in smaller granularity.
     * It can be overriden directly by any handlers if the business logic is relately complex.
     * Otherwise, handlers could override any precise method, like afterInsert, afterUpdate
     * and afterDelete for ease. 
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        // Iterate through the records deleted passing them to the handler.
        if (trgCtx.isDelete) {
            for (SObject so : trgCtx.oldList) {
                this.afterDelete(so);
            }
        }
        
        // Iterate through the records inserted passing them to the handler.
        else if (trgCtx.isInsert) {
            for (SObject so : trgCtx.newList) {
                this.afterInsert(so);
            }
        }
        
        // Iterate through the records updated passing them to the handler.
        else if (trgCtx.isUpdate) {
            for (SObject so : trgCtx.oldList) {
                this.afterUpdate(so, trgCtx.newMap.get(so.Id));
            }
        }
        
    }
    
    /**
     * This method is called iteratively for each record to be inserted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   so   an instance of SObject in trigger.new context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void beforeInsert(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record to be updated during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   oldSo   an instance of SObject in trigger.old context 
     * @param   newSo   an instance of SObject in trigger.new context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record to be deleted during a BEFORE
     * trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   so   an instance of SObject in trigger.old context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void beforeDelete(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record inserted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   so   an instance of SObject in trigger.new context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void afterInsert(SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record updated during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   oldSo   an instance of SObject in trigger.old context 
     * @param   newSo   an instance of SObject in trigger.new context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void afterUpdate(SObject oldSo, SObject so) {
        
    }
    
    /**
     * This method is called iteratively for each record deleted during an AFTER
     * trigger. Always put field validation in the 'After' methods in case another trigger
     * has modified any values. The record is 'read only' by this point.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @param   so   an instance of SObject in trigger.old context 
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void afterDelete(SObject so) {
        
    }
    
    /**
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     *
     * @author  Lingjun Jiang
     * @created 2014-06-07
     * @version 1.0
     * @since   28.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2014-06-07 Lingjun Jiang <lingjun.jiang@itbconsult.com>
     * - Created
     */
    public virtual void andFinally(ClsWrappers.TriggerContext trgCtx) {
        
    }
}