/**
 * Interface containing methods. Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
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
 
public interface IntTrigger {

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
    void bulkBefore(ClsWrappers.TriggerContext trgCtx);

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
    void bulkAfter(ClsWrappers.TriggerContext trgCtx);
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
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
    void beforeTrigger(ClsWrappers.TriggerContext trgCtx);

    /**
     * This method is called for business logic execution of AFTER trigger.
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
    void afterTrigger(ClsWrappers.TriggerContext trgCtx);
    
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
    void andFinally(ClsWrappers.TriggerContext trgCtx);
    
}