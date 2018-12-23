#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: Dataqueue.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/sc_object/SCObject.rb"
require "ttc/bin/sc_object/Dataqueue.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: Dataqueue
  # ��    ��: �ǡ������塼�ξ����������륯�饹
  #===================================================================
  class Dataqueue < SCObject
    #=================================================================
    # ��  ��: �ǡ������塼�ν����
    #=================================================================
    def initialize(sObjectID, hObjectInfo, aPath, bIsPre)
      check_class(String, sObjectID)  # ���֥�������ID
      check_class(Hash, hObjectInfo)  # ���֥������Ⱦ���
      check_class(Array, aPath)       # �롼�Ȥ���Υѥ�
      check_class(Bool, bIsPre)       # pre_condition�⤫

      super(sObjectID, hObjectInfo, TSR_OBJ_DATAQUEUE, aPath, bIsPre)

      @sRefAPI       = FNC_REF_DTQ
      @sRefSWaitAPI  = FNC_REF_SWAIT_DTQ
      @sRefRWaitAPI  = FNC_REF_RWAIT_DTQ
      @sRefStrType   = TYP_T_TTSP_RDTQ
      @sRefStrVar    = GRP_VAR_TYPE[TYP_T_TTSP_RDTQ]
      @sRefAtr       = STR_DTQATR
      @sRefDataCnt   = STR_DTQCNT
      @sRefDataList  = STR_SDTQCNT
      @sRefSWaitList = STR_SWAITCNT
      @sRefRWaitList = STR_RWAITCNT
    end

    #=================================================================
    # ��  ��: ����ե����ե�����˽��Ϥ��륳���ɺ���
    #=================================================================
    def gc_config(cElement)
      check_class(IMCodeElement, cElement) # �������

      cElement.set_config("#{API_CRE_DTQ}(#{@sObjectID}, {#{@hState[TSR_PRM_ATR]}, #{@hState[TSR_PRM_DATACNT]}, NULL});", @hState[TSR_PRM_CLASS]) #[IMCodeElement] �ǡ������塼������������ŪAPI
    end
  end
end
